const { app, BrowserWindow, Menu } = require("electron");

function createWindow() {
  const url = process.argv[2];

  if (!url) {
    console.error("Usage: electron pipview.js <url>");
    app.quit();
    return;
  }

  const win = new BrowserWindow({
    width: 870,
    height: 700,
    autoHideMenuBar: true,
    frame: false,
    show: false,
    webPreferences: {
      contextIsolation: true,
    },
    title: "PIPWindow",
  });

  Menu.setApplicationMenu(null);

  win.loadURL(url);

  win.on("page-title-updated", (e) => e.preventDefault());
  win.webContents.on("did-finish-load", () => {
    win.webContents.insertCSS(`
      ::-webkit-scrollbar {
        display: none;
      }
  
      html, body {
        scrollbar-width: none;   /* Firefox */
        -ms-overflow-style: none; /* IE/Edge legacy */
      }
    `);
  });
win.webContents.once('did-finish-load', () => {
  setTimeout(() => {
    win.show();
  }, 800);
});
}

app.whenReady().then(createWindow);

app.on("window-all-closed", () => app.quit());
