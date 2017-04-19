package audites.application

import audites.domain.Admin
import audites.domain.Audited
import audites.domain.Auditor
import audites.domain.Department
import audites.domain.Revision
import audites.domain.User
import audites.repos.RepoDepartments
import audites.repos.RepoUsers
import org.uqbar.arena.bootstrap.Bootstrap
import audites.domain.Requirement
import audites.repos.RepoRevisions

class AuditesBootstrap implements Bootstrap {

	User admin
	User eschafir
	User dperez
	User rmachado
	User dcullari
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
			addRevision(revision)
		]

		rmachado = new User => [
			name = "Romina Machado"
			username = "rmachado"
			password = "123"
			email = "esteban.schafir@gmail.com"
			addDepartment(seginf)
			roles.add(new Audited)
//			addRevision(revision)
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
		initDepartments
	}

	def void initDepartments() {
		seginf = new Department() => [
			name = "Seguridad Informatica"
			email = "seginf@gmail.com"
			maxAuthority = rmachado
			addRevision(revision)
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
		initRevision
	}

	def initRevision() {
		revision = new Revision() => [
			name = "Revision 1: Usuarios y Perfiles"
			description = "Primera revision asignada a Seguridad Informatica"
			author = dperez
			attendant = rmachado
			responsable = seginf
			addRequirement(new Requirement("Requerimiento 1", "Descripcion del requerimiento 1"))
			addRequirement(new Requirement("Requerimiento 2", "Descripcion del requerimiento 2"))
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
		val listRevisions = repoRev.searchByExample(revision)
		if (listRevisions.isEmpty) {
			repoRev.create(revision)
			println("Revision " + revision.name + " creado")
		} else {
			val revBD = listRevisions.head
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
