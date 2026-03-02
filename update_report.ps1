$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $false
$Excel.DisplayAlerts = $false

$FilePath = "C:\Users\DELL\Videos\astro_user_app-astrobharatai_user\astro_user_app-astrobharatai_user\Daily_Work_Report_2026-02-26.xlsx"

$Workbook = $Excel.Workbooks.Open($FilePath)
$Sheet = $Workbook.Worksheets.Item(1)

# Get last row number as a definite single integer
$LastRowValue = $Sheet.UsedRange.Rows.Count
if ($LastRowValue -is [array]) { $LastRowValue = $LastRowValue[0] }
$LastRow = [int]$LastRowValue

$StartRow = $LastRow + 1
$Today = "2026-02-27"

# Define data rows
# Sr No logic: if LastRow is 4 (header + 3 tasks), next Sr No is 4, 5, 6, 7?
# Actually yesterday ended at 3. So today starts at 4.
$NewTasks = @(
    @("Network & Navigation Stability", "Fixed app crash issues during network toggling and improved navigation state preservation in GlobalNavController and NetworkService."),
    @("Ecommerce & Cart Optimization", "Major updates to CartView, EcommerceHomeView, and CartItemsListWidget for improved cart management and UI reactivity."),
    @("Astrology Services Enhancement", "Refined AllAstrologersView UI and updated AllAstrologersController to handle data more efficiently."),
    @("Dashboard & UI Refinements", "Updated UserMainView, UserDashboardView, and UserBottomNav to improve the main navigation flow and dashboard layout.")
)

for ($i = 0; $i -lt $NewTasks.Length; $i++) {
    $currentRow = $StartRow + $i
    $srNo = [int]$LastRow + $i # This assumes LastRow was the count of rows including header? 
    # Let's just use $currentRow - 1 as a safe bet for Sr No assuming Row 1 is header.
    
    $taskName = $NewTasks[$i][0]
    $taskDetail = $NewTasks[$i][1]
    
    $Sheet.Cells.Item($currentRow, 1) = $currentRow - 1
    $Sheet.Cells.Item($currentRow, 2) = "AstroBharatai"
    $Sheet.Cells.Item($currentRow, 3) = $taskName
    $Sheet.Cells.Item($currentRow, 4) = "Self"
    $Sheet.Cells.Item($currentRow, 5) = $Today
    $Sheet.Cells.Item($currentRow, 6) = $Today
    $Sheet.Cells.Item($currentRow, 7) = $taskDetail
    $Sheet.Cells.Item($currentRow, 8) = "Completed"
}

$Sheet.Columns.AutoFit()
$Workbook.Save()
$Workbook.Close()
$Excel.Quit()

Write-Host "Success: Updated $FilePath with 4 new tasks."
