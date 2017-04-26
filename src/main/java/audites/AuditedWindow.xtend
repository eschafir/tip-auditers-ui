package audites

import audites.AuditedWindows.AttendRevisionWindow
import audites.AuditorWindows.CheckRevisionWindow
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.AuditedAppModel
import audites.appModel.MainApplicationAppModel
import audites.domain.Revision
import audites.domain.User
import java.awt.Color
import javax.swing.JOptionPane
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class AuditedWindow extends DefaultWindow<AuditedAppModel> {

	new(WindowOwner parent, AuditedAppModel model) {
		super(parent, model)
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

		revisionList(principal)
		createRevisionButtons(principal)
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

	protected def revisionList(Panel principal) {

		val tablePanel = new GroupPanel(principal) => [title = ""]
		new Label(tablePanel) => [
			text = "Revisiones asignadas"
			fontSize = 13
		]

		val table = new Table<Revision>(tablePanel, typeof(Revision)) => [
			items <=> "results"
			value <=> "revisionSelected"
			numberVisibleRows = 10
		]

		resultsTableGrid(table)
		revisionAsign(tablePanel)
	}

	protected def createRevisionButtons(Panel panel) {
		val buttonPanel = new GroupPanel(panel) => [title = ""]
		new Button(buttonPanel) => [
			caption = "Atender"
			enabled <=> "revisionIsSelectedAudited"
			onClick[|
				this.close
				new AttendRevisionWindow(this, this.modelObject.revisionSelected, this.modelObject.userLoged).open
			]
			width = 150
			height = 50
		]

		new Button(buttonPanel) => [
			caption = "Ver"
			enabled <=> "revisionIsDerived"
			onClick[|
				new CheckRevisionWindow(this, this.modelObject.revisionSelected, this.modelObject.userLoged).open
			]
			width = 150
			height = 50
		]

		buttonApprove(buttonPanel)
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

		if (modelObject.userLoged.maximumResponsable(this.modelObject.revisionSelected.responsable)) {
			new Column<Revision>(table) => [
				title = "Asignado a"
				bindContentsToProperty("attendant.name")
			]
		}

		new Column<Revision>(table) => [
			title = "Progreso (%)"
			bindContentsToProperty("average")
			bindBackground("isCompleted").transformer = [Boolean completed|if(completed) Color.GREEN else Color.ORANGE]
		]
	}

	def revisionAsign(GroupPanel panel) {
		if (!this.modelObject.userLoged.revisions.empty &&
			this.modelObject.userLoged.maximumResponsable(this.modelObject.revisionSelected.responsable)) {
			val revisionDetailPanel = new GroupPanel(panel) => [title = ""]
			validateMaximumAuthority(revisionDetailPanel)
		}
	}

	def validateMaximumAuthority(Panel mainPanel) {
		val panel = new Panel(mainPanel).layout = new HorizontalLayout
		new Label(panel).text = "Asignar a:"
		new Selector<User>(panel) => [
			allowNull(false)
			enabled <=> "isAsignedToAuthor"
			value <=> "selectedUser"
			(items.bindToProperty("obtainUsers")).adapter = new PropertyAdapter(Revision, "name")
			width = 400
		]
	}

	def buttonApprove(Panel mainPanel) {
		if (!this.modelObject.userLoged.revisions.empty &&
			this.modelObject.userLoged.maximumResponsable(this.modelObject.revisionSelected.responsable)) {
			new Button(mainPanel) => [
				caption = "Aprobar"
				enabled <=> "revisionFinished"
				onClick[|
					openConfirmationDialog
				]
				width = 150
				height = 50
			]
		}
	}

	def openConfirmationDialog() {
		val dialogButton = JOptionPane.YES_NO_OPTION;
		val dialogAnswer = JOptionPane.showConfirmDialog(null,
			"La revision '" + this.modelObject.revisionSelected.name + "' será derivada a " +
				this.modelObject.revisionSelected.author.name + " para su revision final." + "\r\n" +
				"¿Desea continuar?", "question", dialogButton);

			if (dialogAnswer == JOptionPane.YES_OPTION) {
				this.modelObject.deriveToAuthor
			}
		}
	}
	