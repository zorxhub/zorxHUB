<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZorX Hub Broadcast Panel</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        body { 
            background: #0f0f12; 
            color: #f0f0f0; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            margin: 0; 
        }
        .card { 
            background: #16161a; 
            padding: 24px; 
            border-radius: 12px; 
            border: 1px solid #2d2d37; 
            width: 320px; 
            box-shadow: 0 8px 24px rgba(0,0,0,0.5);
        }
        h3 {
            margin-top: 0;
            margin-bottom: 18px;
            color: #fff;
            font-size: 18px;
            text-align: center;
            border-bottom: 1px solid #2d2d37;
            padding-bottom: 10px;
        }
        label {
            font-size: 12px;
            color: #a0a0b0;
            font-weight: bold;
            display: block;
            margin-top: 10px;
            margin-bottom: 4px;
        }
        input, textarea { 
            width: 100%; 
            padding: 10px; 
            background: #22222b; 
            border: 1px solid #3d3d4d; 
            color: #fff; 
            border-radius: 6px; 
            font-size: 13px;
            outline: none;
            transition: border-color 0.2s;
        }
        input:focus, textarea:focus {
            border-color: #9c2ca8;
        }
        textarea {
            resize: none;
        }
        button { 
            width: 100%; 
            padding: 12px; 
            margin-top: 16px;
            background: linear-gradient(135deg, #802380, #9c2ca8); 
            color: #fff; 
            border: none; 
            border-radius: 6px; 
            font-weight: bold; 
            font-size: 13px;
            cursor: pointer; 
            transition: opacity 0.2s, transform 0.1s;
        }
        button:hover { 
            opacity: 0.9;
        }
        button:active {
            transform: scale(0.98);
        }
        .status-msg {
            font-size: 11px;
            text-align: center;
            margin-top: 10px;
            height: 14px;
            font-weight: bold;
        }
        .success { color: #4CAF50; }
        .error { color: #f44336; }
    </style>
</head>
<body>
    <div class="card">
        <h3>ZorX Broadcast Panel</h3>
        
        <label>Asset ID Foto Logo Roblox:</label>
        <input type="text" id="iconId" value="134572030759999" placeholder="Contoh: 134572030759999">

        <label>Pesan Notifikasi:</label>
        <textarea id="pesan" rows="3" placeholder="Tulis pesan siaran di sini..."></textarea>
        
        <button id="btnKirim" onclick="kirimPesan()">Kirim ke Roblox</button>
        <div id="status" class="status-msg"></div>
    </div>

    <script>
        function kirimPesan() {
            const pesanInput = document.getElementById("pesan");
            const iconInput = document.getElementById("iconId");
            const btn = document.getElementById("btnKirim");
            const status = document.getElementById("status");

            const isiPesan = pesanInput.value.trim();
            const idFoto = iconInput.value.trim() || "134572030759999";
            const waktuSekarang = Math.floor(Date.now() / 1000);

            if (!isiPesan) {
                status.className = "status-msg error";
                status.innerText = "Isi pesan tidak boleh kosong!";
                return;
            }

            // Ubah status tombol saat mengirim
            btn.disabled = true;
            btn.innerText = "Mengirim...";
            status.innerText = "";

            const data = {
                Pesan: isiPesan,
                IconId: idFoto,
                Waktu: waktuSekarang
            };

            const dbURL = "https://zorx-broadcast-default-rtdb.firebaseio.com/broadcast.json";

            fetch(dbURL, {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(data)
            })
            .then(response => {
                if(response.ok) {
                    status.className = "status-msg success";
                    status.innerText = "✓ Berhasil dikirim ke Roblox!";
                    pesanInput.value = ""; // Bersihkan kolom teks otomatis
                } else {
                    status.className = "status-msg error";
                    status.innerText = "Gagal mengirim pesan.";
                }
            })
            .catch(error => {
                console.error("Error:", error);
                status.className = "status-msg error";
                status.innerText = "Terjadi kesalahan koneksi.";
            })
            .finally(() => {
                btn.disabled = false;
                btn.innerText = "Kirim ke Roblox";
                
                // Hapus pesan status setelah 3 detik
                setTimeout(() => {
                    status.innerText = "";
                }, 3000);
            });
        }
    </script>
</body>
</html>
