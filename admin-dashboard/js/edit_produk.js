// js/edit_produk.js
const token = localStorage.getItem("token");
const data = JSON.parse(localStorage.getItem("editProduk"));

if (!data) {
  alert("Data produk tidak ditemukan.");
  window.location.href = "dashboard.html";
}

document.getElementById("editId").value = data._id;
document.getElementById("editNama").value = data.name;
document.getElementById("editHarga").value = data.harga;
document.getElementById("editDeskripsi").value = data.deskripsi;

document.getElementById("formEditProduk").addEventListener("submit", async (e) => {
  e.preventDefault();
  const body = {
    name: document.getElementById("editNama").value,
    harga: document.getElementById("editHarga").value,
    deskripsi: document.getElementById("editDeskripsi").value,
    foto: "" // tidak mengubah foto
  };

  const res = await fetch(`http://localhost:5000/api/products/${data._id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(body),
  });

  if (res.ok) {
    alert("Produk berhasil diubah!");
    localStorage.removeItem("editProduk");
    window.location.href = "dashboard.html";
  } else {
    alert("Gagal mengubah produk.");
  }
});
