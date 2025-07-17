const token = localStorage.getItem("token");

const form = document.getElementById("formProduk");
form.addEventListener("submit", async (e) => {
  e.preventDefault();

  const name = document.getElementById("namaProduk").value;
  const harga = document.getElementById("hargaProduk").value;
  const deskripsi = document.getElementById("deskripsiProduk").value;
  const foto = document.getElementById("fotoProduk").files[0];

  console.log("Submitting:", { name, harga, deskripsi, foto });

  if (!foto) {
    alert("Foto produk wajib diisi!");
    return;
  }

  const formData = new FormData();
  formData.append("name", name);
  formData.append("harga", harga);
  formData.append("deskripsi", deskripsi);
  formData.append("foto", foto);

  const res = await fetch("http://localhost:5000/api/products", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  });

  const result = await res.text();
  console.log("Response:", result);

  if (res.ok) {
    alert("Produk berhasil ditambahkan!");
    window.location.href = "dashboard.html";
  } else {
    alert("Gagal menambahkan produk:\n" + result);
  }
});
