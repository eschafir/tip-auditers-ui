package audites

import audites.AuditorWindows.CheckRevisionWindow
import audites.AuditorWindows.EditRevisionWindow
import audites.AuditorWindows.NewRevisionWindow
import audites.DefaultWindow.DefaultWindow
import audites.Transformers.AverageStatusTransformer
import audites.appModel.AuditorAppModel
import audites.appModel.MainApplicationAppModel
import audites.appModel.NewRevisionAppModel
import audites.domain.Revision
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

		val principal = new Panel(mainPanel)
		principal.layout = new HorizontalLayout

		revisionsList(principal)
		revisionsDetail(principal)

	}

	def searchBar(Panel panel) {
		val searchPanel = new Panel(panel) => [layout = new HorizontalLayout]

		new Label(searchPanel) => [
			text = "Buscar: "
		]

		new TextBox(searchPanel) => [
			value <=> "revisionSearch"
			width = 200
		]
	}

	def revisionsList(Panel mainPanel) {
		val principal = new GroupPanel(mainPanel) => [title = ""]
		new Label(principal) => [
			text = "Revisiones generadas"
			fontSize = 13
		]

		val table = new Table<Revision>(principal, typeof(Revision)) => [
			items <=> "results"
			value <=> "revisionSelected"
		]

		this.describeResultsGrid(table)

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

	def describeResultsGrid(Table<Revision> table) {
		new Column<Revision>(table) => [
			title = "Nombre"
			fixedSize = 200
			bindContentsToProperty("name")
		]
	}

	def revisionsDetail(Panel mainPanel) {
		val principal = new GroupPanel(mainPanel) => [title = ""]

		new Label(principal) => [
			text = "Detalles"
			fontSize = 13
		]
		val panel = new Panel(principal).layout = new HorizontalLayout
		new Label(panel).text = "Departamento: "
		new Label(panel) => [
			value <=> "revisionSelected.responsable.name"
			width = 200
		]
		infoProgress(principal)
	}

	def infoProgress(Panel mainPanel) {
		val panel = new Panel(mainPanel).layout = new HorizontalLayout
		new Label(panel) => [
			text = "Progreso: "
			(background <=> "revisionSelected.average").transformer = new AverageStatusTransformer
		]
		new Label(panel) => [
			(background <=> "revisionSelected.average").transformer = new AverageStatusTransformer
			value <=> "revisionSelected.average"
		]
		new Label(panel) => [
			(background <=> "revisionSelected.average").transformer = new AverageStatusTransformer
			text = "%"
		]
	}
}
