allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// Alguns plugins (ex.: flutter_native_splash) fixam um compileSdk antigo (31),
// o que falha com dependências androidx que exigem compilar contra a API 33/34+.
// Forçamos todos os módulos Android a compilar contra a SDK 36.
// IMPORTANTE: registrar este afterEvaluate ANTES do bloco evaluationDependsOn
// abaixo, senão o subprojeto já estará avaliado e o afterEvaluate falha.
subprojects {
    afterEvaluate {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            try {
                val setter = androidExt.javaClass.getMethod(
                    "compileSdkVersion", Int::class.javaPrimitiveType
                )
                setter.invoke(androidExt, 36)
            } catch (_: Exception) {
                // Módulo sem método compileSdkVersion(Int) — ignora.
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
