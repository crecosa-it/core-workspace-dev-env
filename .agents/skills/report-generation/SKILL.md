---
name: report-generation
description: Guide and architectural pattern for creating new reports in the api-report service. Covers the Strategy Pattern, Clean Architecture layers, DataHandlers, PdfHandlers, and HTML templates.
---

# Skill: Credit Core Report Generation Pattern

## Objective

When requested to create, modify, or review a report in the `api-report` module (`d:\Proyectos\Credit_Core_Work_Space\api-report\reportApi\Features\CreditReports`), enforce and utilize the modular Clean Architecture and Strategy Pattern specifically devised for report generation.

Never write or add functionality to deprecated monolithic services like `CreditReportsServices.cs`.

## The Architectural Pattern

The reporting module uses a **Vertical Slice** Clean Architecture joined with a **Strategy Pattern** and a **Factory Pattern** to completely separate data gathering, mapping, and visual generation (HTML to PDF).

1. **API Layer (Controller + Factory):**
   `CreditReportsController.cs` receives a generic HTTP request containing the `nameOfReport` and `type` (pdf/json). It uses `IReportStrategyFactory` to delegate execution. It does NOT contain routing logic for individual reports.

2. **Application Layer (The Strategy Implementation):**
   Every report must reside in its own dedicated folder (e.g., `Application/MyNewReport/`). This folder must contain three core files:
   - `[Name]FeatureModels.cs`: DTO definitions and Mapper interfaces.
   - `[Name]DataHandler.cs`: Acts as the orchestrator for reading from the Infrastructure `CreditReportsRepository.cs`. It maps native EF Core entities to the specific DTOs using `FeatureModels`.
   - `[Name]PdfHandler.cs`: Implements `IReportStrategy`. It retrieves the enriched DTO from the `DataHandler` and translates it into an HTML template structure using `IReportBuilder` or dictionary mapping.

3. **Infrastructure Layer (Templates & Generation):**
   - Generates the PDF via an external `IHtmlToPdfGenerate` tool.
   - Depends on raw `.html` files located in `Infrastructure/Reporting/Templates/[Name].html`.

4. **Multi-Database Support (Crucial for Distributed Environments):**
   - If a report requires data from an external database (e.g., `guaranteedb`), do NOT add it to the main `CreditReportsContextCtpaga`.
   - Create a dedicated `DbContext` (e.g., `GuaranteesContext.cs`) with its own connection string in `appsettings.json`.
   - Inject both contexts into the repository to maintain independence and support multi-server production environments.

## Step-by-Step: Adding a New Report

When instructed to create a new report, execute exactly these five steps:

### Step 1: Create the Feature Models

Establish the DTO and Mapper within `Application/[ReportName]/[ReportName]FeatureModels.cs`.

### Step 2: Create the Data Handler

Create `Application/[ReportName]/[ReportName]DataHandler.cs`. Use it solely to request data from the repository, apply cross-table enrichments, and return the DTO.

### Step 3: Create the PDF Handler

Create `Application/[ReportName]/[ReportName]PdfHandler.cs` implementing `IReportStrategy`. Connect it to the `DataHandler` to get data, map the data directly to template placeholders, and invoke the HTML-to-PDF conversion.

### Step 4: Register in the Factory

Modify `Infrastructure/Reporting/ReportStrategyFactory.cs` to map the specific string name (e.g., `"MyNewReport"`) to your new `[ReportName]PdfHandler` implementation inside the switch statement.

### Step 5: Add the HTML Template

- **Scalar Fields:** Use single braces `{PropertyName}` (e.g., `<p>{ClientName}</p>`).
- **Lists/Loops:** Use `{{FOR:ListName}}` and `{{ENDFOR:ListName}}` (e.g., `{{FOR:Guarantees}} <tr><td>{{Value}}</td></tr> {{ENDFOR:Guarantees}}`).
- **Conditionals:** Use `{{IF:PropertyName}}` and `{{ENDIF:PropertyName}}`.

File location: `Infrastructure/Reporting/Templates/[ReportName].html`.

**Consistent Header & Aesthetic Rules:**
1. **No CSS Variables:** The HTML-to-PDF converter does NOT support CSS variables (`var(--...)`). All colors and dimensions must be hardcoded as hex values (e.g., `#0a4d8c`).
2. **Minimalist Design:** Avoid heavy use of solid primary colors as backgrounds (e.g., solid blue banners). Use white space, thin borders (1px/1.5px), and light background tints (`#f8fafc`, `#f1f5f9`) for a professional, printable result.
3. **Branding:** Use the Crecosa primary blue (`#0a4d8c`) primarily for titles, bold accents, and thin borders, not for full-page blocks.
4. **Header Consistency:** All new report templates MUST share a consistent header design containing the company logo, report title, evaluation date, and client name, following the layout established in `BalanceSheet.html` or `BusinessAnalystDetailed.html`.

## Conventions and Formatting

- **Currency:** Use `ReportFormattingUtils.FormatCurrency(amount, currencyCode)` for any monetary values.
- **Decimals:** Format explicitly as `.ToString("F2")` in DataHandlers or use clear formatting in the HTML.
- **Dates:** Presentation standard: `.ToString("dd/MM/yyyy")`.
- **Booleans:** If using template conditionals (`{{IF:Flag}}`), ensure the DTO or the mapping dictionary contains a boolean property with the exact same name as the flag.
- **IDs:** `ClientCode` is the unique customer ID; `ApplicationCode` is the Credit Request ID; `CreditCode` is the active disbursed credit ID.
