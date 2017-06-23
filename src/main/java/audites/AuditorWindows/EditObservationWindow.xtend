package audites.AuditorWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.EditObservationAppModel
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner
import audites.domain.Observation
import audites.domain.User
import org.uqbar.arena.widgets.TextBox
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.widgets.Button
import audites.domain.Revision
import org.uqbar.arena.widgets.Label

class EditObservationWindow extends DefaultWindow<EditObservationAppModel> {

	new(WindowOwner parent, Observation obs, User user, Revision revision) {
		super(parent, new EditObservationAppModel(obs, user, revision))
	}

	override createWindowToFormPanel(Panel panel) {
		new Label(panel) => [
			text = "Observación de: " + modelObject.observation.requirement.name
			fontSize = 10
		]
		new TextBox(panel) => [
			width = 300
			height = 300
			fontSize = 8
			multiLine = true
			value <=> "comments"
		]
	}

	override createButtonPanels(Panel panel) {
		new Button(panel) => [
			caption = "Aceptar"
			setAsDefault
			onClick[|
				modelObject.saveComment
				this.close
				new GenerateReportWindow(this, modelObject.userLoged, modelObject.revision).open
			]
		]
		new Button(panel) => [
			caption = "Cancelar"
			onClick[|
				this.close
				new GenerateReportWindow(this, modelObject.userLoged, modelObject.revision).open
			]
		]
	}

}
