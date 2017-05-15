package audites.AuditorWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.GenerateReportAppModel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.widgets.TextBox
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.widgets.Button

class GenerateReportWindow extends DefaultWindow<GenerateReportAppModel> {

	new(WindowOwner parent, User user, Revision revision) {
		super(parent, new GenerateReportAppModel(user, revision))
	}

	override createWindowToFormPanel(Panel panel) {
		val imagePanel = new Panel(panel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		new Label(panel).text = modelObject.report.name
		new TextBox(panel) => [
			multiLine = true
			height = 200
			width = 500
			value <=> "observations"
		]
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
