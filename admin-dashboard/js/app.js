async function login() {
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value.trim();
  
    try {
      const response = await fetch(`${BASE_URL}/api/auth/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json", "ngrok-skip-browser-warning": "true" },
        body: JSON.stringify({ email, password }),
      });
  
      const data = await response.json();
  
      if (response.ok) {
        if (data.user.role === "admin") {
          localStorage.setItem("token", data.token);
          localStorage.setItem("name", data.user.name);
          window.location.href = "dashboard.html";
        } else {
          alert("Akses ditolak: Bukan admin");
        }
      } else {
        alert(data.message);
      }
    } catch (err) {
      alert("Terjadi kesalahan: " + err.message);
    }
  }
  