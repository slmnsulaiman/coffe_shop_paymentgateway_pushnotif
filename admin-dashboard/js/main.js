const name = localStorage.getItem("name");
const token = localStorage.getItem("token");
document.getElementById("adminName").textContent = name ?? "Admin";

function logout() {
  localStorage.clear();
  window.location.href = "index.html";
}

function showPage(page) {
  document.querySelectorAll(".page").forEach(p => p.classList.add("hidden"));
  document.getElementById(`${page}Page`).classList.remove("hidden");
}

async function fetchUsers() {
  const res = await fetch(`${BASE_URL}/api/users`, {
    headers: {
      Authorization: `Bearer ${token}`,
      "ngrok-skip-browser-warning": "true"
    },
  });

  const data = await res.json();
  const tbody = document.getElementById("userTableBody");
  tbody.innerHTML = "";

  if (res.ok) {
    data.users.forEach((user, index) => {
      tbody.innerHTML += `<tr><td>${index + 1}</td><td>${user.name}</td><td>${user.email}</td></tr>`;
    });
  }
}

async function fetchProduk() {
  const res = await fetch(`${BASE_URL}/api/products`, {
    headers: {
      Authorization: `Bearer ${token}`,
      "ngrok-skip-browser-warning": "true"
    },
  });

  const data = await res.json();
  const tbody = document.getElementById("produkTableBody");
  tbody.innerHTML = "";

  if (res.ok) {
    for (let i = 0; i < data.products.length; i++) {
      const p = data.products[i];

      // Gunakan /api di depan path gambar agar bisa lewat ngrok
      const imageUrl = `${BASE_URL}/api${p.foto}`;

      tbody.innerHTML += `
        <tr>
          <td>${i + 1}</td>
          <td>${p.name}</td>
          <td>Rp ${p.harga.toLocaleString()}</td>
          <td><img src="${imageUrl}" width="50" onerror="this.style.display='none'"></td>
          <td>${p.deskripsi}</td>
          <td>
            <button class="btn btn-warning btn-sm me-2" onclick='editProduk(${JSON.stringify(p)})'>Edit</button>
            <button class="btn btn-danger btn-sm" onclick="hapusProduk('${p._id}')">Hapus</button>
          </td>
        </tr>`;
    }
  }
}

function editProduk(produk) {
  localStorage.setItem("editProduk", JSON.stringify(produk));
  window.location.href = "edit_produk.html";
}

async function hapusProduk(id) {
  if (!confirm("Yakin ingin menghapus produk ini?")) return;

  const res = await fetch(`${BASE_URL}/api/products/${id}`, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${token}`,
      "ngrok-skip-browser-warning": "true"
    },
  });

  if (res.ok) {
    alert("Produk dihapus!");
    fetchProduk();
  }
}

// Panggil fungsi awal
fetchUsers();
fetchProduk();
