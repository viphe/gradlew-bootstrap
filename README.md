# gradlew-bootstrap

A slow but easy way of installing the Gradle wrapper in any new project folder.

For the latest:

    curl -sSL https://raw.githubusercontent.com/viphe/gradlew-bootstrap/master/run.sh | \
        bash -s

Nightly:

    curl -sSL https://raw.githubusercontent.com/viphe/gradlew-bootstrap/master/run.sh | \
        bash -s nightly


Arbitrary version:

    curl -sSL https://raw.githubusercontent.com/viphe/gradlew-bootstrap/master/run.sh | \
        bash -s 2.2


The script downloads the specified binary distribution of Gradle and runs `gradle wrapper` with it.
This means that Gradle might re-download the same distribution the first time you will run
`./gradlew`.
