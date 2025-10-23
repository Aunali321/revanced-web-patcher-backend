import org.gradle.api.tasks.Sync
import org.gradle.jvm.toolchain.JavaLanguageVersion
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    kotlin("jvm") version "2.0.20"
    application
}

group = "app.revanced"
version = "1.0.0"

repositories {
    mavenCentral()
    google()
    maven {
        // A repository must be specified for some reason. "registry" is a dummy.
        url = uri("https://maven.pkg.github.com/revanced/registry")
        credentials {
            username = project.findProperty("gpr.user") as String? ?: System.getenv("GITHUB_ACTOR")
            password = project.findProperty("gpr.key") as String? ?: System.getenv("GITHUB_TOKEN")
        }
    }
}

kotlin {
    jvmToolchain(17)
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
        freeCompilerArgs.add("-Xcontext-receivers")
    }
}

java {
    toolchain.languageVersion.set(JavaLanguageVersion.of(17))
}

dependencies {
    implementation("io.ktor:ktor-server-core-jvm:2.3.7")
    implementation("io.ktor:ktor-server-netty-jvm:2.3.7")
    implementation("io.ktor:ktor-server-default-headers:2.3.7")
    implementation("io.ktor:ktor-server-status-pages:2.3.7")
    implementation("io.ktor:ktor-server-content-negotiation-jvm:2.3.7")
    implementation("io.ktor:ktor-server-cors-jvm:2.3.7")
    implementation("io.ktor:ktor-serialization-jackson-jvm:2.3.7")
    implementation("io.ktor:ktor-server-call-logging-jvm:2.3.7")
    implementation("ch.qos.logback:logback-classic:1.4.14")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.8.1")

    implementation("app.revanced:revanced-patcher:21.0.0")
    implementation("app.revanced:revanced-library:3.1.0")

    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.17.2")
    implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310:2.17.2")

    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

application {
    mainClass.set("app.revanced.webpatcher.ApplicationKt")
}

val installDistTask = tasks.named<Sync>("installDist")

tasks.register("localDist") {
    dependsOn(installDistTask)
    val outputDir = layout.buildDirectory.dir("local-dist")
    doLast {
        val target = outputDir.get().asFile
        if (target.exists()) target.deleteRecursively()
        target.mkdirs()
        installDistTask.get().destinationDir.copyRecursively(target, overwrite = true)
    }
}
