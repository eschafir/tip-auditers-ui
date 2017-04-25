package audites.TemplatesWindows

import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.layout.HorizontalLayout

abstract class DefaultWindow<T> extends SimpleWindow<T> {

	new(WindowOwner parent, T model) {
		super(parent, model)
	}

	override protected addActions(Panel actionsPanel) {
		val buttonsPanel = new Panel(actionsPanel) => [layout = new HorizontalLayout]
		createButtonPanels(buttonsPanel)
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "AuditERS"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/src/main/resources/logo.png"
		createWindowToFormPanel(mainPanel)
	}

	abstract def void createWindowToFormPanel(Panel panel)

	abstract def void createButtonPanels(Panel panel)

	override createContents(Panel mainPanel) {
		createFormPanel(mainPanel)
		addActions(mainPanel)
	}

}
