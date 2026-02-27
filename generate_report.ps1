$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $false
$Excel.DisplayAlerts = $false
$Workbook = $Excel.Workbooks.Add()
$Sheet = $Workbook.Worksheets.Item(1)

# Set Headers
$Headers = @("Sr . No", "Project", "Task", "Assigned By", "Assigned Date", "Assigned Target", "Task Completed Details", "Status")
for ($i = 0; $i -lt $Headers.Length; $i++) {
    $Sheet.Cells.Item(1, $i + 1) = $Headers[$i]
    $Sheet.Cells.Item(1, $i + 1).Font.Bold = $true
}

# Data for 2026-02-26
$Data = @(
    @(1, "AstroBharatai", "Match Making Fixes", "Self", "2026-02-26", "2026-02-26", "Fixed Papasamaya scoring percentage bug (733%), normalized MatchMakingResultView keys to fix 'No data' errors, updated labels to be dynamic, and improved UI badge visibility.", "Completed"),
    @(2, "AstroBharatai", "Kundli Form Redesign", "Self", "2026-02-26", "2026-02-26", "Implemented two-tab layout (Saved/New Kundli), added Kundli Profile CRUD APIs, and updated controller with 'Save Your Kundli' checkbox functionality.", "Completed"),
    @(3, "AstroBharatai", "Navigation Rewrite", "Self", "2026-02-26", "2026-02-26", "Rewrote navigation system using IndexedStack with per-tab Navigators for state preservation and implemented custom back navigation logic.", "Completed")
)

# Populate Data
for ($row = 0; $row -lt $Data.Length; $row++) {
    for ($col = 0; $col -lt $Data[$row].Length; $col++) {
        $Sheet.Cells.Item($row + 2, $col + 1) = $Data[$row][$col]
    }
}

# Auto-fit columns
$Sheet.Columns.AutoFit()

# Save
$FilePath = "C:\Users\DELL\Videos\astro_user_app-astrobharatai_user\astro_user_app-astrobharatai_user\Daily_Work_Report_2026-02-26.xlsx"
$Workbook.SaveAs($FilePath)
$Excel.Quit()

echo "File saved to $FilePath"
