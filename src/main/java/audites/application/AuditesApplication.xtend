package audites.application

import audites.Login.LoginWindows
import org.uqbar.arena.Application
import org.uqbar.arena.windows.Window

class AuditesApplication extends Application {

	new(AuditesBootstrap bootstrap) {
		super(bootstrap)
	}

	override protected Window<?> createMainWindow() {
		new LoginWindows(this)

	}

	def static main(String[] args) {
		new AuditesApplication(new AuditesBootstrap).start()
	}

}
