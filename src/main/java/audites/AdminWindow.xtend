package audites

import audites.AdminWindows.EditUserWindow
import audites.AdminWindows.NewUserWindow
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.AdminPanelAppModel
import audites.appModel.MainApplicationAppModel
import audites.domain.User
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class AdminWindow extends DefaultWindow<AdminPanelAppModel> {

	new(WindowOwner parent, User user) {
		super(parent, new AdminPanelAppModel(user))
		modelObject.search
	}

	override createButtonPanels(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Atras"
			onClick[|
				this.close
				new MainApplicationWindows(this, new MainApplicationAppModel(this.modelObject.userLoged)).open
			]
		]
	}

	override createWindowToFormPanel(Panel mainPanel) {

		val imagePanel = new Panel(mainPanel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]
		
		new Label(imagePanel) => [text = "\r\n" + "Usuario: " + modelObject.userLoged.name]

		searchBar(mainPanel)
		revisionsList(mainPanel)
	}

	def searchBar(Panel panel) {
		val groupPanel = new GroupPanel(panel) => [
			title = ""
		]

		val searchPanel = new Panel(groupPanel) => [layout = new HorizontalLayout]

		new Label(searchPanel) => [
			text = "Buscar: "
		]

		new TextBox(searchPanel) => [
			value <=> "userSearch"
			width = 200
		]
	}

	def revisionsList(Panel mainPanel) {

		val principal = new Panel(mainPanel)
		principal.layout = new HorizontalLayout

		val tablePanel = new GroupPanel(principal) => [title = ""]
		new Label(tablePanel) => [
			text = "Usuarios"
			fontSize = 13
		]

		val table = new Table<User>(tablePanel, typeof(User)) => [
			items <=> "results"
			value <=> "selectedUser"
			numberVisibleRows = 10
		]

		resultsTableGrid(table)
		createUserButtons(tablePanel)
	}

	def resultsTableGrid(Table<User> table) {

		new Column<User>(table) => [
			title = "Usuario"
			bindContentsToProperty("username")
		]

		new Column<User>(table) => [
			title = "Nombre"
			bindContentsToProperty("name")
		]

		new Column<User>(table) => [
			title = "Email"
			bindContentsToProperty("email")
		]

		new Column<User>(table) => [
			title = "Departamentos"
			bindContentsToProperty("departmentsNames")
		]

		new Column<User>(table) => [
			title = "Status"
			bindContentsToProperty("enabled").transformer = [Boolean enabled|
				if(enabled) "Habilitado" else "Deshabilitado"
			]
		]

	}

	def createUserButtons(GroupPanel principal) {
		val options = new Panel(principal).layout = new HorizontalLayout

		new Button(options) => [
			caption = "Nuevo"
			fontSize = 10
			width = 140
			height = 40
			onClick[|
				this.close
				new NewUserWindow(this, modelObject.userLoged).open
			]
		]

		new Button(options) => [
			caption = "Editar"
			fontSize = 10
			width = 140
			height = 40
			visible <=> "hasUserSelected"
			onClick[|
				this.close
				new EditUserWindow(this, modelObject.userLoged, modelObject.selectedUser).open
			]
		]
	}
}
