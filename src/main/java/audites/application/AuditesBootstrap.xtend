package audites.application

import audites.domain.Admin
import audites.domain.Audited
import audites.domain.Auditor
import audites.domain.Department
import audites.domain.Role
import audites.domain.User
import audites.repos.RepoDepartments
import audites.repos.RepoUsers
import org.uqbar.arena.bootstrap.Bootstrap
import audites.repos.RepoRoles

class AuditesBootstrap implements Bootstrap {

	User admin
	User eschafir
	User dperez
	User rmachado
	User dcullari
	User mdiez
	Role administrator
	Role auditor
	Role audited
	Department seginf
	Department legales
	Department riesgos
	Department auditoria
	Department rrhh

	def void initUsers() {

		admin = new User() => [
			name = "Administrador"
			username = "admin"
			password = "admin"
			email = "admin"
			addRole(administrator)
		]

		eschafir = new User => [
			name = "Esteban Schafir"
			username = "eschafir"
			password = "123"
			email = "esteban.schafir@gmail.com"
			addRole(audited)
			addDepartment(seginf)
			addDepartment(riesgos)
		]

		dperez = new User => [
			name = "Diego Perez"
			username = "dperez"
			password = "123"
			email = "esteban.schafir@gmail.com"
			addRole(auditor)
		]

		rmachado = new User => [
			name = "Romina Machado"
			username = "rmachado"
			password = "123"
			email = "esteban.schafir@gmail.com"
			addRole(audited)
			addDepartment(seginf)
			addDepartment(auditoria)
		]

		mdiez = new User => [
			name = "Marcelo Diez"
			username = "mdiez"
			password = "123"
			email = "esteban.schafir@gmail.com"
			addRole(audited)
			addDepartment(auditoria)
		]

		dcullari = new User => [
			name = "Daniel Cullari"
			username = "dcullari"
			password = "123"
			email = "esteban.schafir@gmail.com"
			addRole(audited)
			addDepartment(seginf)
		]

		createUser(admin)
		createUser(eschafir)
		createUser(dperez)
		createUser(rmachado)
		createUser(dcullari)
		createUser(mdiez)
		initRoles
		initDepartments
	}

	def void initRoles() {
		administrator = new Admin
		auditor = new Auditor
		audited = new Audited

		createRole(administrator)
		createRole(auditor)
		createRole(audited)
	}

	def void initDepartments() {
		seginf = new Department() => [
			name = "Seguridad Informatica"
			email = "seginf@gmail.com"
			maxAuthority = rmachado
		]

		legales = new Department() => [
			name = "Legales"
			email = "legales@gmail.com"
		]

		riesgos = new Department() => [
			name = "Riesgos"
			email = "riesgos@gmail.com"
			maxAuthority = eschafir
		]

		auditoria = new Department() => [
			name = "Auditoria Interna"
			email = "ai@gmail.com"
			maxAuthority = mdiez
		]

		rrhh = new Department() => [
			name = "Recursos Humanos"
			email = "rrhh@gmail.com"
		]

		createDepartment(seginf)
		createDepartment(legales)
		createDepartment(riesgos)
		createDepartment(auditoria)
		createDepartment(rrhh)
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
			user.name = userBD.name
			user.email = userBD.email
			user.username = userBD.username
			user.roles = userBD.roles
			user.departments = userBD.departments
			user.revisions = userBD.revisions
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
			department.name = depBD.name
			department.email = depBD.email
			department.revisions = depBD.revisions
			repoDep.update(department)
		}
	}

	def createRole(Role role) {
		val repoRoles = RepoRoles.instance
		val listRoles = repoRoles.searchByExample(role)
		if (listRoles.isEmpty) {
			repoRoles.create(role)
			println("Rol " + role.name + " creado")
		} else {
			val roleBD = listRoles.head
			role.id = roleBD.id
			role.name = roleBD.name
			repoRoles.update(role)
		}
	}

	override isPending() {
		false
	}

	override run() {
		initRoles
		initDepartments
		initUsers
	}
}
