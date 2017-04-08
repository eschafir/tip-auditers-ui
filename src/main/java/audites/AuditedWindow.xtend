package audites

import audites.AuditedWindows.AttendRevisionWindow
import audites.appModel.AuditedAppModel
import audites.appModel.MainApplicationAppModel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.layout.HorizontalLayout

class AuditedWindow extends SimpleWindow<AuditedAppModel> {

	new(WindowOwner parent, AuditedAppModel model) {
		super(parent, model)
		this.taskDescription = "Revisiones asignadas"
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
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
		val principal = new Panel(mainPanel)
		principal.layout = new HorizontalLayout

		val ppanel = new Panel(principal)

		new List<Revision>(ppanel) => [
			value <=> "revisionSelected"
			(items.bindToProperty("userLoged.revisions")).adapter = new PropertyAdapter(Revision, "name")
			height = 150
			width = 200
		]

		new Button(ppanel) => [
			caption = "Atender"
			enabled <=> "revisionIsSelected"
			onClick[|
				new AttendRevisionWindow(this, this.modelObject.revisionSelected, this.modelObject.userLoged).open
			]
		]

		validateMaximumAuthority(ppanel)
		revisionDetail(principal)
	}

	def revisionDetail(Panel panel) {
		if (!this.modelObject.userLoged.revisions.empty &&
			this.modelObject.userLoged.maximumResponsable(this.modelObject.revisionSelected.responsable)) {
			new Label(panel).text = "Asignado a: "
			new Label(panel) => [
				value <=> "revisionSelected.attendant.name"
			]
		}
	}

	def validateMaximumAuthority(Panel mainPanel) {
		if (!this.modelObject.userLoged.revisions.empty &&
			this.modelObject.userLoged.maximumResponsable(this.modelObject.revisionSelected.responsable)) {
			new Label(mainPanel).text = "Asignar a..."
			new Selector<User>(mainPanel) => [
				allowNull(false)
				value <=> "selectedUser"
				(items.bindToProperty("obtainUsers")).adapter = new PropertyAdapter(Revision, "name")
				onSelection[|
					this.modelObject.applyAttendant
				]
			]
		}
	}
}
