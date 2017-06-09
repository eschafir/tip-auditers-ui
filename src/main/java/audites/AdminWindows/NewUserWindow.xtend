package audites.AdminWindows

import audites.AdminWindow
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.NewUserAppModel
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
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class NewUserWindow extends DefaultWindow<NewUserAppModel> {

	new(WindowOwner parent, User user) {
		super(parent, new NewUserAppModel(user))
	}

	override createWindowToFormPanel(Panel panel) {
		val imagePanel = new Panel(panel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		new Label(panel) => [
			text = "Nuevo Usuario"
			fontSize = 15
		]

		userInfoFields(panel)
		departmentFields(panel)
		rolesFields(panel)

	}

	override createButtonPanels(Panel panel) {
		new Button(panel) => [
			caption = "Aceptar"
			onClick[|
				modelObject.save()
				this.close
				new AdminWindow(this, modelObject.userLoged).open
			]
		]

		new Button(panel) => [
			caption = "Cancelar"
			onClick[|
				this.close
				modelObject.cancelCreation
				new AdminWindow(this, modelObject.userLoged).open
			]
		]
	}

	def userInfoFields(Panel panel) {
		val userInfoPanel = new Panel(panel) => [layout = new ColumnLayout(2)]
		new Label(userInfoPanel).text = "User ID"
		new TextBox(userInfoPanel) => [
			value <=> "user.username"
			width = 200
		]

		new Label(userInfoPanel).text = "Contraseña"
		new PasswordField(userInfoPanel) => [
			value <=> "passwordIngresed"
			width = 200
		]

		new Label(userInfoPanel).text = "Nombre Completo"
		new TextBox(userInfoPanel) => [
			value <=> "user.name"
			width = 200
		]

		new Label(userInfoPanel).text = "Email"
		new TextBox(userInfoPanel) => [
			value <=> "user.email"
			width = 200
		]
	}

	def departmentFields(Panel panel) {
		new Label(panel).text = "Departamentos"

		new List<Department>(panel) => [
			value <=> "selectedDepartment"
			(items.bindToProperty("user.departments")).adapter = new PropertyAdapter(Department, "name")
			height = 50
			width = 200
		]

		new Selector(panel) => [
			width = 185
			allowNull(false)
			value <=> "selectorDepartment"
			(items.bindToProperty("departments")).adapter = new PropertyAdapter(Department, "name")
		]

		val depButtons = new Panel(panel) => [layout = new HorizontalLayout]
		new Button(depButtons) => [
			caption = "Agregar"
			enabled <=> "isDepartmentIngresed"
			onClick[|
				modelObject.createUser
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

	def rolesFields(Panel panel) {
		new Label(panel).text = "Roles"

		new List<Department>(panel) => [
			value <=> "selectedRole"
			(items.bindToProperty("user.roles")).adapter = new PropertyAdapter(Role, "name")
			height = 50
			width = 200
		]

		new Selector(panel) => [
			width = 185
			allowNull(false)
			value <=> "selectorRole"
			(items.bindToProperty("roles")).adapter = new PropertyAdapter(Role, "name")
		]

		val roleButtons = new Panel(panel) => [layout = new HorizontalLayout]
		new Button(roleButtons) => [
			caption = "Agregar"
			enabled <=> "isRoleIngresed"
			onClick[|
				modelObject.createUser
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

}
