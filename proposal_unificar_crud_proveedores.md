# Proposal: Unificar CRUD Proveedores

## Intent
Solve technical debt: duplicated validation logic, mixed PHP/HTML concerns, and 4 separate files for provider CRUD operations.

## Scope
### In Scope
- Single HTML page (proveedores.php) showing provider table and add/edit form
- Unified processing (guardarProv.php) for create and update operations
- Delete action remains in eliminarProv.php (unchanged for now)

### Out of Scope
- Changing delete to use POST or adding confirmation
- Adding new features (search, pagination)
- Modifying database schema

## Capabilities
### New Capabilities
None

### Modified Capabilities
None

## Approach
- Create proveedores.php: contains HTML table of providers and a form for add/edit.
- Form submits to guardarProv.php via POST.
- guardarProv.php determines operation (create/update) by presence of 'id' field.
- Extract validation and DB connection to include/common.php.
- For editing: proveedores.php reads 'edit' GET param to load provider data into form.
- Use Post/Redirect/Get in guardarProv.php to avoid form resubmission.
- Keep eliminarProv.php as-is (GET-based delete) for this refactor.

## Affected Areas
| Area | Impact | Description |
|------|--------|-------------|
| src/modulos/compras_provision/proveedores/proveedores.php | New | Unified HTML page with table and form |
| src/modulos/compras_provision/proveedores/guardarProv.php | New | Unified create/update processing |
| src/modulos/compras_provision/proveedores/include/common.php | New | Shared DB connection and validation functions |
| src/modulos/compras_provision/proveedores/consultarProv.php | Removed | Replaced by proveedores.php |
| src/modulos/compras_provision/proveedores/añadirProv.php | Removed | Replaced by new page and processor |
| src/modulos/compras_provision/proveedores/editarProv.php | Removed | Replaced by new page and processor |
| src/modulos/compras_provision/proveedores/eliminarProv.php | Unchanged | Delete action kept as-is |

## Risks
| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Broken links to old files | Medium | Update internal links; add temporary redirects if needed |
| Form resubmission on refresh | Low | Implement Post/Redirect/Get pattern |
| Loss of functionality during transition | Low | Test thoroughly; keep backup of old files |

## Rollback Plan
Revert the Git commit that adds the new files and removes the old ones. Restore the previous state of the provider CRUD files.

## Dependencies
None

## Success Criteria
- [ ] Single page shows provider list + form
- [ ] Edit loads data into form via GET parameter
- [ ] guardarProv.php handles both create and update
- [ ] Delete action still works (unchanged)
- [ ] No duplicated validation logic
- [ ] Consistent flash messaging