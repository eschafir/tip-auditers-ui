package audites.AuditorWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.GenerateOrEditReportAppModel
import audites.domain.Observation
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner

class GenerateReportWindow extends DefaultWindow<GenerateOrEditReportAppModel> {

	new(WindowOwner parent, User user, Revision revision) {
		super(parent, new GenerateOrEditReportAppModel(user, revision))
		if (revision.report == null) {
			modelObject.createReport
		}
	}

	override createWindowToFormPanel(Panel panel) {
		val imagePanel = new Panel(panel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		new Label(panel) => [
			text = "Reporte de " + modelObject.revision.name
			fontSize = 10
		]

		for (Observation obs : modelObject.revision.report.observations) {
			new Label(panel) => [
				text = obs.requirement.name
				fontSize = 11
			]

			new Label(panel) => [
				text = obs.comment
				fontSize = 11
			]

			new Button(panel) => [
				caption = "Editar observacion"
				onClick[|
					this.close
					new EditObservationWindow(this, obs, this.modelObject.userLoged, modelObject.revision).open
				]
			]
		}

	}

	override createButtonPanels(Panel panel) {
		new Button(panel) => [
			caption = "Aceptar"
			setAsDefault
			onClick[|
				modelObject.saveOrUpdateReport
				this.close
			]
		]
	}

}
