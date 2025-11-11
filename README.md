# Nafass Application

Offline-first Flutter application that stores all user generated data in local
JSON files.

## Local authentication data

The authentication module persists users in a writable copy of the
`assets/data/user.json` asset. On first launch the bundled asset is copied to a
`data_dev` directory that sits alongside the project source. Subsequent
read/write operations update the JSON file inside that folder, which keeps the
bundled asset unchanged for version control.

After registering an account you will find the generated file at
`data_dev/user.json` relative to the project root.