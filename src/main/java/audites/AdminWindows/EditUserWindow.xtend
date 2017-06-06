package audites.AdminWindows

import audites.AdminWindow
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.EditUserAppModel
import audites.domain.Department
import audites.domain.Role
import audites.domain.User
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class EditUserWindow extends DefaultWindow<EditUserAppModel> {

	new(WindowOwner parent, User user, User toEdit) {
		super(parent, new EditUserAppModel(user, toEdit))
	}

	override createWindowToFormPanel(Panel panel) {

		val imagePanel = new Panel(panel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		new Label(panel) => [
			text = "Editar Usuario"
			fontSize = 15
		]

		val userInfo = new Panel(panel) => [layout = new ColumnLayout(3)]
		new Label(userInfo) => [
			text = "User ID:"
			fontSize = 10
		]
		new Label(userInfo) => [text = modelObject.user.username]
		new Label(userInfo)

		new Label(userInfo) => [
			text = "Nombre Completo:"
			fontSize = 10
		]
		new Label(userInfo) => [value <=> "user.name"]
		new Button(userInfo) => [
			caption = "Editar..."
			onClick[|new EditUserName(this, modelObject.user, modelObject.user.name).open]
		]

		new Label(userInfo) => [
			text = "Email:"
			fontSize = 10
		]
		new Label(userInfo) => [value <=> "user.email"]
		new Button(userInfo) => [
			caption = "Editar..."
			onClick[|new EditUserEmail(this, modelObject.user, modelObject.user.email).open]
		]

		departmentEdition(panel)
		rolesEdition(panel)

		val passAndStatus = new Panel(panel) => [
			width = 300
			layout = new HorizontalLayout
		]
		new Button(passAndStatus) => [
			caption = "Cambiar Contraseña"
			fontSize = 10
			onClick[|new EditUserPassword(this, modelObject.user, modelObject.passwordIngresed).open]
		]

		statusButton(passAndStatus)

	}

	override createButtonPanels(Panel panel) {
		new Button(panel) => [
			caption = "Aceptar"
			onClick[|
				this.close
				new AdminWindow(this, modelObject.userLoged).open
			]
		]
	}

	def departmentEdition(Panel panel) {
		val depPanel = new Panel(panel)
		new Label(depPanel).text = "Departamentos"

		new List<Department>(depPanel) => [
			value <=> "selectedDepartment"
			(items.bindToProperty("userDepartments")).adapter = new PropertyAdapter(Department, "name")
			height = 50
			width = 200
		]

		new Selector(depPanel) => [
			width = 185
			allowNull(false)
			value <=> "selectorDepartment"
			(items.bindToProperty("departments")).adapter = new PropertyAdapter(Department, "name")
		]

		val depButtons = new Panel(depPanel) => [layout = new HorizontalLayout]
		new Button(depButtons) => [
			caption = "Agregar"
			enabled <=> "isDepartmentIngresed"
			onClick[|
				modelObject.addDepartment
			]
		]

		new Button(depButtons) => [
			caption = "Eliminar"
			enabled <=> "isDepartmentSelected"
			onClick[|
				modelObject.removeDepartment
			]
		]
	}

	def rolesEdition(Panel panel) {
		val rolePanel = new Panel(panel)
		new Label(rolePanel).text = "Roles"

		new List<Department>(rolePanel) => [
			value <=> "selectedRole"
			(items.bindToProperty("userRoles")).adapter = new PropertyAdapter(Role, "name")
			height = 50
			width = 200
		]

		new Selector(rolePanel) => [
			width = 185
			allowNull(false)
			value <=> "selectorRole"
			(items.bindToProperty("roles")).adapter = new PropertyAdapter(Role, "name")
		]

		val roleButtons = new Panel(rolePanel) => [layout = new HorizontalLayout]
		new Button(roleButtons) => [
			caption = "Agregar"
			enabled <=> "isRoleIngresed"
			onClick[|
				modelObject.addRole
			]
		]

		new Button(roleButtons) => [
			caption = "Eliminar"
			enabled <=> "isRoleSelected"
			onClick[|
				modelObject.removeRole
			]
		]
	}

	def statusButton(Panel panel) {
		if (modelObject.user.enabled) {
			new Button(panel) => [
				caption = "Deshabilitar"
				fontSize = 10
				visible <=> "userIsEnabled"
				onClick[|
					modelObject.changeUserStatus
					this.close
					new EditUserWindow(this, modelObject.userLoged, modelObject.user).open
				]
			]
		} else {
			new Button(panel) => [
				caption = "Habilitar"
				fontSize = 10
				visible <=> "userIsDisabled"
				onClick[|
					modelObject.changeUserStatus
					this.close
					new EditUserWindow(this, modelObject.userLoged, modelObject.user).open
				]
			]
		}
	}

}
