package audites

import audites.AuditorWindows.CheckRevisionWindow
import audites.AuditorWindows.EditRevisionWindow
import audites.AuditorWindows.NewRevisionWindow
import audites.DefaultWindow.DefaultWindow
import audites.appModel.AuditorAppModel
import audites.appModel.MainApplicationAppModel
import audites.appModel.NewRevisionAppModel
import audites.domain.Revision
import audites.domain.User
import java.awt.Color
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

class AuditorWindow extends DefaultWindow<AuditorAppModel> {

	new(WindowOwner parent, User user) {
		super(parent, new AuditorAppModel(user))
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

		searchBar(mainPanel)
		revisionsList(mainPanel)
	}

	def searchBar(Panel panel) {
		val searchPanel = new GroupPanel(panel) => [
			title = ""
			layout = new HorizontalLayout
		]

		new Label(searchPanel) => [
			text = "Buscar: "
		]

		new TextBox(searchPanel) => [
			value <=> "revisionSearch"
			width = 200
		]
	}

	def revisionsList(Panel mainPanel) {
		
		val principal = new Panel(mainPanel)
		principal.layout = new HorizontalLayout

		val tablePanel = new GroupPanel(principal) => [title = ""]
		new Label(tablePanel) => [
			text = "Revisiones generadas"
			fontSize = 13
		]

		val table = new Table<Revision>(tablePanel, typeof(Revision)) => [
			items <=> "results"
			value <=> "revisionSelected"
			numberVisibleRows = 10
		]

		resultsTableGrid(table)
		createRevisionButtons(tablePanel)
	}

	def resultsTableGrid(Table<Revision> table) {
		new Column<Revision>(table) => [
			title = "Nombre"
			fixedSize = 250
			bindContentsToProperty("name")
		]

		new Column<Revision>(table) => [
			title = "Departamento"
			fixedSize = 180
			bindContentsToProperty("responsable.name")
		]

		new Column<Revision>(table) => [
			title = "Creada"
			bindContentsToProperty("initDate")
		/**
		 * Poner un transformer de fecha del estilo "DD-MM-AAAA"
		 */
		]

		new Column<Revision>(table) => [
			title = "Finaliza"
			bindContentsToProperty("endDate")
		/**
		 * Poner un transformer de fecha del estilo "DD-MM-AAAA"
		 * y un transforme de color para indicar si venció o no.
		 */
		]

		new Column<Revision>(table) => [
			title = "Progreso (%)"
			bindContentsToProperty("average")
			bindBackground("isCompleted").transformer = [Boolean completed|if(completed) Color.GREEN else Color.ORANGE]
		]
	}

	def createRevisionButtons(GroupPanel principal) {
		val options = new Panel(principal).layout = new HorizontalLayout

		new Button(options) => [
			caption = "Nueva"
			onClick[|
				this.close
				new NewRevisionWindow(this, new NewRevisionAppModel(this.modelObject.userLoged)).open

			]
		]

		new Button(options) => [
			caption = "Ver"
			enabled <=> "revisionIsSelectedAuditor"
			onClick[|
				new CheckRevisionWindow(this, this.modelObject.revisionSelected, this.modelObject.userLoged).open
			]
		]

		new Button(options) => [
			caption = "Editar"
			enabled <=> "revisionIsNotFinished"
			onClick[|
				new EditRevisionWindow(this, this.modelObject.revisionSelected).open
			]
		]
	}
}
