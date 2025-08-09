# Tasks

## VAN Process Meta
- [x] Review existing Decidim modules for implementation patterns <!-- Complexity: Medium -->
- [x] Analyze current implementation before starting new tasks <!-- Complexity: Medium -->

## Implementation Tasks
- [ ] Create a simple Decidim module with an admin menu element called `decidim-theme-maker` <!-- Complexity: Medium -->
- [ ] Enable access to `/admin/theme_maker` index page via the menu button <!-- Complexity: Low -->
- [ ] Add UI elements to the index page to display uploaded CSS files and provide an "Add new CSS" button <!-- Complexity: Medium -->
- [ ] Add a delete button for each uploaded file <!-- Complexity: Medium -->
- [ ] Implement `/admin/theme_maker/new` page accessible via the "Add new CSS" button, with input for name, file upload, and save button <!-- Complexity: Medium-High -->
- [ ] Use permissions logic correctly <!-- Complexity: Medium -->

---

## PLAN Mode: Implementation Breakdown

### Overview of Changes
Implement a Decidim module (`decidim-theme-maker`) with an admin menu, index and new pages, CSS file management (list, add, delete), and correct permissions.

### Files to Modify
- `lib/decidim/theme/maker/menu.rb` (admin menu registration)
- `app/controllers/decidim/theme/maker/admin/theme_maker_controller.rb` (index/new actions, file logic)
- `app/views/decidim/theme/maker/admin/theme_maker/index.html.erb` (UI for listing, add/delete)
- `app/views/decidim/theme/maker/admin/theme_maker/new.html.erb` (UI for upload form)
- `app/models/decidim/theme/maker/theme_file.rb` (file model)
- `app/forms/decidim/theme/maker/admin/theme_file_form.rb` (file upload form)
- `app/assets/stylesheets/decidim/theme/maker/application.css` (styling)
- `config/routes.rb` (routes for new/index/delete)
- `app/permissions/decidim/theme/maker/admin/permissions.rb` (permissions logic)

### Implementation Steps
1. **Admin Menu:**  
   Ensure menu item is visible and links to `/admin/theme_maker`.
2. **Index Page:**  
   - List uploaded CSS files.
   - Add "Add new CSS" button.
   - Add delete button for each file.
3. **New Page:**  
   - Form for name and file upload.
   - Save button to create/upload CSS file.
4. **Backend Logic:**  
   - Implement file listing, creation, and deletion in controller/model.
   - Use form object for file upload.
5. **Permissions:**  
   - Restrict actions to authorized users using Decidim permissions.
6. **Styling:**  
   - Apply basic styles for admin UI.

### Potential Challenges
- Handling file uploads securely.
- Ensuring only CSS files are accepted.
- Integrating with Decidim’s permission system.
- UI/UX consistency with Decidim admin.

### Testing Strategy
- Manual test: Add, list, and delete CSS files as an admin.
- Attempt unauthorized access to ensure permissions work.
- Upload invalid files to test validation.
