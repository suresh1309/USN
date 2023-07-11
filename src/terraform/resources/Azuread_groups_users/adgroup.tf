data "azuread_user" "user" {
  for_each            = toset(var.group_members)
  user_principal_name = each.key
}

resource "azuread_group" "adgroup_name" {
  display_name     = var.adgroup_name
  security_enabled = true
}

resource "azuread_group_member" "member" {
  for_each         = toset(var.group_members)
  group_object_id  = azuread_group.adgroup_name.id
  member_object_id = data.azuread_user.user[each.key].id
}

