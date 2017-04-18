package audites.application

import org.uqbar.arena.bootstrap.Bootstrap
import audites.domain.User
import audites.repos.RepoUsers
import audites.domain.Admin
import audites.domain.Department
import audites.repos.RepoDepartments
import audites.domain.Auditor
import audites.domain.Audited
import audites.domain.Revision
import java.util.Date
import audites.domain.Requirement
import audites.repos.RepoRevisions

class AuditesBootstrap implements Bootstrap {

	User admin
	User eschafir
	User dperez
	User rmachado
	User dcullari
	User mdiez
	Department seginf
	Department legales
	Department riesgos
	Department auditoria
	Department rrhh
	Revision revision

	def void initUsers() {

		admin = new User() => [
			name = "Administrador"
			username = "admin"
			password = "admin"
			email = "admin"
			roles.add(new Admin)
			roles.add(new Auditor)
			roles.add(new Audited)
		]

		eschafir = new User => [
			name = "Esteban Schafir"
			username = "eschafir"
			password = "123"
			email = "esteban.schafir@gmail.com"
			roles.add(new Audited)
			addDepartment(seginf)
		]

		dperez = new User => [
			name = "Diego Perez"
			username = "dperez"
			password = "123"
			email = "esteban.schafir@gmail.com"
			roles.add(new Auditor)
			revisions.add(revision)
		]

		rmachado = new User => [
			name = "Romina Machado"
			username = "rmachado"
			password = "123"
			email = "esteban.schafir@gmail.com"
			addDepartment(seginf)
			roles.add(new Audited)
		]
		
		mdiez = new User =>[
			name = "Marcelo Diez"
			username = "mdiez"
			password = "123"
			email = "esteban.schafir@gmail.com"
			addDepartment(legales)
			roles.add(new Audited)
		]

		dcullari = new User => [
			name = "Daniel Cullari"
			username = "dcullari"
			password = "123"
			email = "esteban.schafir@gmail.com"
			roles.add(new Audited)
			addDepartment(seginf)
		]
		this.createUser(admin)
		this.createUser(eschafir)
		this.createUser(dperez)
		this.createUser(rmachado)
		this.createUser(dcullari)
		this.createUser(mdiez)
		initDepartments
	}

	def void initDepartments() {
		seginf = new Department() => [
			name = "Seguridad Informatica"
			email = "seginf@gmail.com"
			maxAuthority = rmachado
			revisions.add(revision)
		]

		legales = new Department() => [
			name = "Legales"
			email = "legales@gmail.com"
		]

		riesgos = new Department() => [
			name = "Riesgos"
			email = "riesgos@gmail.com"
		]

		auditoria = new Department() => [
			name = "Auditoria Interna"
			email = "ai@gmail.com"
		]

		rrhh = new Department() => [
			name = "Recursos Humanos"
			email = "rrhh@gmail.com"
		]

		this.createDepartment(seginf)
		this.createDepartment(legales)
		this.createDepartment(riesgos)
		this.createDepartment(auditoria)
		this.createDepartment(rrhh)
	}

	def initRevision() {
		revision = new Revision =>
			[
				name = "Revision 1: Usuarios y perfiles"
				description = "Revision de usuarios y perfiles para Seguridad Informatica."
				author = dperez
				endDate = new Date()
				responsable = seginf
				attendant = rmachado
				requirements = #[new Requirement("Requerimiento 1", "Descripcion del requerimiento 1"),
					new Requirement("Requerimiento 2", "Descripcion del requerimiento 2")]
			]
		this.createRevision(revision)
	}

	def createUser(User user) {
		val repoUsers = RepoUsers.instance
		val listUsers = repoUsers.searchByExample(user)
		if (listUsers.isEmpty) {
			repoUsers.create(user)
			println("User " + user.name + " creado")
		} else {
			val userBD = listUsers.head
			user.id = userBD.id
			repoUsers.update(user)
		}
	}

	def createDepartment(Department department) {
		val repoDep = RepoDepartments.instance
		val listDepartments = repoDep.searchByExample(department)
		if (listDepartments.isEmpty) {
			repoDep.create(department)
			println("Department " + department.name + " creado")
		} else {
			val depBD = listDepartments.head
			department.id = depBD.id
			repoDep.update(department)
		}
	}

	def createRevision(Revision revision) {
		val repoRev = RepoRevisions.instance
		val listRevision = repoRev.searchByExample(revision)
		if (listRevision.isEmpty) {
			repoRev.create(revision)
			println("Revision " + revision.name + " creada")
		} else {
			val revBD = listRevision.head
			revision.id = revBD.id
			repoRev.update(revision)
		}
	}

	override isPending() {
		false
	}

	override run() {
		initRevision
		initDepartments
		initUsers
	}

}
