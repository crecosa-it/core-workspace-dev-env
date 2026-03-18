# Start Dev Environment for Credit Core
Write-Host "Starting Credit Legacy UI and Credit API..." -ForegroundColor Cyan

# Start Credit Legacy UI in a new window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'd:\Proyectos\Credit_Core_Work_Space\ui-legacy'; nvm use 14.17.3; npm start"

# Start Credit API in a new window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'd:\Proyectos\Credit_Core_Work_Space\api-credit\creApiRest'; dotnet run"

# Start BackOffice API in a new window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'd:\Proyectos\Credit_Core_Work_Space\api-backoffice\BackOfficeManager.Api'; dotnet run"

Write-Host "Processes started in separate windows." -ForegroundColor Green
