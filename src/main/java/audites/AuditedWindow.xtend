package audites

import audites.AuditedWindows.AttendRevisionWindow
import audites.AuditorWindows.CheckRevisionWindow
import audites.Transformers.AverageStatusTransformer
import audites.appModel.AuditedAppModel
import audites.appModel.MainApplicationAppModel
import audites.domain.Revision
import audites.domain.User
import javax.swing.JOptionPane
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.graphics.Image

class AuditedWindow extends SimpleWindow<AuditedAppModel> {

	new(WindowOwner parent, AuditedAppModel model) {
		super(parent, model)
		this.taskDescription = "Panel de Auditado"
	}

	override createContents(Panel mainPanel) {
		createFormPanel(mainPanel)
		addActions(mainPanel)
	}

	override protected addActions(Panel actionsPanel) {
		val buttonPanel = new Panel(actionsPanel)
		new Button(buttonPanel) => [
			caption = "Atras"
			onClick[|
				this.close
				new MainApplicationWindows(this, new MainApplicationAppModel(this.modelObject.userLoged)).open
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Audites"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		val imagePanel = new Panel(mainPanel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		val principal = new Panel(mainPanel)
		principal.layout = new HorizontalLayout

		revisionList(principal)
		revisionDetail(principal)
	}

	protected def revisionList(Panel principal) {
		val ppanel = new GroupPanel(principal) => [title = ""]

		new Label(ppanel) => [
			text = "Revisiones Asignadas"
			fontSize = 13
		]

		new List<Revision>(ppanel) => [
			value <=> "revisionSelected"
			(items.bindToProperty("userLoged.revisions")).adapter = new PropertyAdapter(Revision, "name")
			height = 250
			width = 250
		]

		val buttonPanel = new Panel(ppanel)
		buttonPanel.layout = new HorizontalLayout
		new Button(buttonPanel) => [
			caption = "Atender"
			enabled <=> "revisionIsSelectedAudited"
			onClick[|
				this.close
				new AttendRevisionWindow(this, this.modelObject.revisionSelected, this.modelObject.userLoged).open
			]
		]

		new Button(buttonPanel) => [
			caption = "Ver"
			enabled <=> "revisionIsDerived"
			onClick[|
				new CheckRevisionWindow(this, this.modelObject.revisionSelected, this.modelObject.userLoged).open
			]
		]

		buttonApprove(buttonPanel)
	}

	def revisionDetail(Panel panel) {
		if (!this.modelObject.userLoged.revisions.empty &&
			this.modelObject.userLoged.maximumResponsable(this.modelObject.revisionSelected.responsable)) {

			val revisionDetailPanel = new GroupPanel(panel) => [title = ""]
			new Label(revisionDetailPanel) => [
				text = "Detalles"
				fontSize = 13
			]

			validateMaximumAuthority(revisionDetailPanel)
			infoAssigned(revisionDetailPanel)
			infoProgress(revisionDetailPanel)
		}
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

	def infoAssigned(Panel mainPanel) {
		val panel = new Panel(mainPanel).layout = new HorizontalLayout
		new Label(panel).text = "Asignado a: "
		new Label(panel) => [
			value <=> "revisionSelected.attendant.name"
		]
	}

	def validateMaximumAuthority(Panel mainPanel) {
		val panel = new Panel(mainPanel).layout = new HorizontalLayout
		new Label(panel).text = "Asignar a:"
		new Selector<User>(panel) => [
			allowNull(false)
			enabled <=> "isAsignedToAuthor"
			value <=> "selectedUser"
			(items.bindToProperty("obtainUsers")).adapter = new PropertyAdapter(Revision, "name")
			width = 200
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
	