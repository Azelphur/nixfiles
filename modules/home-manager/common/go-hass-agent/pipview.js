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
    height: 755,

    autoHideMenuBar: true,

    webPreferences: {
      contextIsolation: true,
    },
    title: "PIPWindow",
  });

  Menu.setApplicationMenu(null);

  win.loadURL(url);

  win.on("page-title-updated", (e) => e.preventDefault());
}

app.whenReady().then(createWindow);

app.on("window-all-closed", () => app.quit());
