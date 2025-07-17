document.addEventListener("DOMContentLoaded", () => {
  fetchAndRender();
});

async function fetchAndRender() {
  const tbody = document.getElementById("checkoutTableBody");
  tbody.innerHTML = `<tr><td colspan="8" class="text-center">Memuat data...</td></tr>`;

  try {
    const res = await fetch(`${BASE_URL}/api/checkout`, {
      headers: { "ngrok-skip-browser-warning": "true" }
    });
    const data = await res.json();

    const type = document.getElementById("filterType").value;
    const waktu = document.getElementById("filterWaktu").value;
    const bulan = parseInt(document.getElementById("filterBulan").value);
    const tahun = parseInt(document.getElementById("filterTahun").value);

    let filtered = data;

    // Filter metode
    if (type === "Cash") {
      filtered = filtered.filter(i => i.metode === "Cash");
    } else if (type === "Gateway") {
      filtered = filtered.filter(i => i.metode !== "Cash");
    }

    // Filter waktu
    const now = new Date();

    if (waktu === "Today") {
      filtered = filtered.filter(i => {
        const tgl = new Date(i.createdAt);
        return (
          tgl.getDate() === now.getDate() &&
          tgl.getMonth() === now.getMonth() &&
          tgl.getFullYear() === now.getFullYear()
        );
      });
    } else if (waktu === "Week") {
      let startDate, endDate;

      if (bulan > 0 && tahun > 0) {
        endDate = new Date(tahun, bulan - 1, 31, 23, 59, 59);
        startDate = new Date(endDate);
        startDate.setDate(endDate.getDate() - 6);
      } else {
        endDate = new Date();
        startDate = new Date();
        startDate.setDate(endDate.getDate() - 6);
      }

      filtered = filtered.filter(i => {
        const tgl = new Date(i.createdAt);
        return tgl >= startDate && tgl <= endDate;
      });
    } else if (waktu === "Month") {
      if (bulan > 0 && tahun > 0) {
        filtered = filtered.filter(i => {
          const tgl = new Date(i.createdAt);
          return tgl.getMonth() + 1 === bulan && tgl.getFullYear() === tahun;
        });
      }
    }

    renderCheckout(filtered);
    renderChart(filtered);
  } catch (err) {
    console.error("Gagal ambil data checkout:", err);
    tbody.innerHTML = `<tr><td colspan="8" class="text-danger text-center">Gagal ambil data</td></tr>`;
  }
}

function renderCheckout(data) {
  const tbody = document.getElementById("checkoutTableBody");
  tbody.innerHTML = "";

  if (!data.length) {
    tbody.innerHTML = `<tr><td colspan="8" class="text-center text-muted">Belum ada transaksi</td></tr>`;
    return;
  }

  data.forEach((item, index) => {
    const tr = document.createElement("tr");

    tr.innerHTML = `
      <td>${index + 1}</td>
      <td>${item.userName}</td>
      <td>${item.userEmail}</td>
      <td>${item.metode}</td>
      <td>${item.type || '-'}</td>
      <td>Rp ${item.total.toLocaleString('id-ID')}</td>
      <td><span class="badge bg-${getStatusColor(item.status)}">${item.status}</span></td>
      <td>${new Date(item.createdAt).toLocaleString('id-ID')}</td>
    `;

    tbody.appendChild(tr);
  });
}

function getStatusColor(status) {
  switch (status) {
    case 'success': return 'success';
    case 'pending': return 'warning';
    case 'failed': return 'danger';
    default: return 'secondary';
  }
}

// Statistik Chart
function renderChart(data) {
  const waktu = document.getElementById("filterWaktu").value;
  const bulan = parseInt(document.getElementById("filterBulan").value);
  const tahun = parseInt(document.getElementById("filterTahun").value);

  const labels = [];
  const dataCash = [];
  const dataGateway = [];

  const formatLabel = (d) => `${d.getDate()}/${d.getMonth() + 1}`;

  if (waktu === "Today") {
    labels.push("Hari Ini");
    dataCash.push(data.filter(i => i.metode === "Cash").length);
    dataGateway.push(data.filter(i => i.metode !== "Cash").length);
  } else if (waktu === "Week") {
    let endDate, startDate;

    if (bulan > 0 && tahun > 0) {
      endDate = new Date(tahun, bulan - 1, 31, 23, 59, 59);
    } else {
      endDate = new Date();
    }

    startDate = new Date(endDate);
    startDate.setDate(endDate.getDate() - 6);

    for (let d = new Date(startDate); d <= endDate; d.setDate(d.getDate() + 1)) {
      const label = formatLabel(d);
      labels.push(label);

      const dailyCash = data.filter(i => {
        const tgl = new Date(i.createdAt);
        return tgl.toDateString() === d.toDateString() && i.metode === "Cash";
      }).length;

      const dailyGateway = data.filter(i => {
        const tgl = new Date(i.createdAt);
        return tgl.toDateString() === d.toDateString() && i.metode !== "Cash";
      }).length;

      dataCash.push(dailyCash);
      dataGateway.push(dailyGateway);
    }
  } else if (waktu === "Month") {
    if (bulan > 0 && tahun > 0) {
      const daysInMonth = new Date(tahun, bulan, 0).getDate();
      for (let day = 1; day <= daysInMonth; day++) {
        const label = `${day}/${bulan}`;
        labels.push(label);

        const dailyCash = data.filter(i => {
          const tgl = new Date(i.createdAt);
          return tgl.getDate() === day &&
                 tgl.getMonth() + 1 === bulan &&
                 tgl.getFullYear() === tahun &&
                 i.metode === "Cash";
        }).length;

        const dailyGateway = data.filter(i => {
          const tgl = new Date(i.createdAt);
          return tgl.getDate() === day &&
                 tgl.getMonth() + 1 === bulan &&
                 tgl.getFullYear() === tahun &&
                 i.metode !== "Cash";
        }).length;

        dataCash.push(dailyCash);
        dataGateway.push(dailyGateway);
      }
    }
  }

  const ctx = document.getElementById("chartMetode").getContext("2d");
  if (window.chartInstance) window.chartInstance.destroy();

  window.chartInstance = new Chart(ctx, {
    type: "bar",
    data: {
      labels,
      datasets: [
        {
          label: "Cash",
          data: dataCash,
          backgroundColor: "#198754"
        },
        {
          label: "Payment Gateway",
          data: dataGateway,
          backgroundColor: "#0d6efd"
        }
      ]
    },
    options: {
      responsive: true,
      scales: {
        y: {
          beginAtZero: true,
          ticks: { precision: 0 }
        }
      }
    }
  });
}
