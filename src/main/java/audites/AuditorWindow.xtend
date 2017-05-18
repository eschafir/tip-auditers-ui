package audites

import audites.AuditorWindows.CheckRevisionWindow
import audites.AuditorWindows.EditRevisionWindow
import audites.AuditorWindows.GenerateReportWindow
import audites.AuditorWindows.NewRevisionWindow
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.AuditorAppModel
import audites.appModel.MainApplicationAppModel
import audites.appModel.NewRevisionAppModel
import audites.domain.Revision
import audites.domain.User
import java.awt.Color
import java.util.Date
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.CheckBox
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

		new Label(imagePanel) => [text = "\r\n" + "Usuario: " + modelObject.userLoged.name]

		searchBar(mainPanel)
		revisionsList(mainPanel)
	}

	def searchBar(Panel panel) {
		val groupPanel = new GroupPanel(panel) => [
			title = ""
		]

		val searchPanel = new Panel(groupPanel) => [layout = new HorizontalLayout]
		val checkBoxPanel = new Panel(groupPanel) => [layout = new HorizontalLayout]

		new Label(searchPanel) => [
			text = "Buscar: "
		]

		new TextBox(searchPanel) => [
			value <=> "revisionSearch"
			width = 200
		]

		new Label(checkBoxPanel) => [
			text = "Mostrar archivadas "
			fontSize = 8
		]

		new CheckBox(checkBoxPanel) => [
			value <=> "withArchivedRevisions"
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
			bindContentsToProperty("name")
		]

		new Column<Revision>(table) => [
			title = "Departamento"
			bindContentsToProperty("responsable.name")
		]

		new Column<Revision>(table) => [
			title = "Creada"
			bindContentsToProperty("initDate").transformer = [Date date|modelObject.formatDate(date)]
		]

		new Column<Revision>(table) => [
			title = "Finaliza"
			bindContentsToProperty("endDate").transformer = [Date date|modelObject.formatDate(date)]
			bindBackground("isExpiredAndNotCompleted").transformer = [Boolean expired|
				if(!expired) Color.WHITE else Color.RED
			]
		]

		new Column<Revision>(table) => [
			title = "Progreso"
			bindContentsToProperty("average").transformer = [Float avg|modelObject.formatAverage(avg)]
			bindBackground("isCompleted").transformer = [Boolean completed|if(completed) Color.GREEN else Color.WHITE]
		]

		new Column<Revision>(table) => [
			title = "Archivada"
			bindContentsToProperty("archived").transformer = [Boolean archived|if(archived) "Si" else "No"]
		]
	}

	def createRevisionButtons(GroupPanel principal) {
		val options = new Panel(principal).layout = new HorizontalLayout

		new Button(options) => [
			caption = "Nueva"
			fontSize = 10
			width = 140
			height = 40
			onClick[|
				this.close
				new NewRevisionWindow(this, new NewRevisionAppModel(this.modelObject.userLoged)).open

			]
		]

		new Button(options) => [
			caption = "Ver"
			fontSize = 10
			width = 140
			height = 40
			enabled <=> "revisionIsSelectedAuditor"
			onClick[|
				new CheckRevisionWindow(this, this.modelObject.revisionSelected, this.modelObject.userLoged).open
			]
		]

		new Button(options) => [
			caption = "Editar"
			fontSize = 10
			width = 140
			height = 40
			enabled <=> "revisionIsNotFinished"
			onClick[|
				new EditRevisionWindow(this, this.modelObject.revisionSelected).open
			]
		]

		new Button(options) => [
			caption = "Generar informe"
			fontSize = 10
			width = 140
			height = 40
			visible <=> "revisionCompletedAndAsigned"
			onClick[|
				new GenerateReportWindow(this, modelObject.userLoged, modelObject.revisionSelected).open
			]
		]

		new Button(options) => [
			caption = "Archivar"
			fontSize = 10
			width = 140
			height = 40
			visible <=> "revisionCompletedAndAsigned"
			onClick[|
				modelObject.archive
			]
		]
	}
}
