# Current code inventory

Selected October 28, 2026; project fingerprints refreshed October 29, 2026. The owner designated workspace copies as the source
and requested tracking all existing library binaries initially. This inventory
identifies the copied baseline; it does not establish deployed versions, a
successful compile, or that each library is a resolved project dependency.

The October 29 CODESYS extraction confirms the ASIN bounds correction in the
current saved PLC project. Original ZIP archives remain historical review inputs;
current loose export directories were compared with newly generated output.
See [CODESYS_EXPORTS](CODESYS_EXPORTS.md) for source hashes, coverage, and the
unresolved-library limitations. This table fingerprints binary/archive inputs;
readable-export validation is recorded there separately.

The [original assessment baseline](SOURCE_BASELINE.md) preserves the provenance
of the earlier review. [DEVELOPMENT](DEVELOPMENT.md) owns the update and backup
workflow, including the hold on the differing Box PLC project.

| Workspace file | Bytes | SHA-256 |
| --- | ---: | --- |
| `Production_dev/TD3-Auto/ojjo_TD3_cr711S_530v1.project` | 3120334 | `eb39fe01c8bf5dcdc873e062de2177c10bf91aa55d363a1769d989c049a8b3d1` |
| `Production_dev/TD3-Auto/exports_ojjo_TD3_cr711S_530v1.zip` | 517681 | `a6a5631cf65a7353bffe910c6bf18b8044e5a59df4071fb1e249fc62888f8ea5` |
| `Production_dev/TD3-HMI/ojjo_TD3_cr1203_530v1.project` | 9948704 | `ad4fb78de83fa85d38f8e1bafd03178d6fb3d57bd2586765ce9490395fd65af3` |
| `Production_dev/TD3-HMI/exports_ojjo_TD3_cr1203_530v1.zip` | 276031 | `3d23432e7fb07d3079c295c0a35548edecdf9fa5c699348e04b7c6db6a711cb5` |
| `Library/gps.library` | 255954 | `3e2f53993dd7857e2326ad74e3a435ab74e381d9a9e84eb63afe73978ff71b32` |
| `Library/motor3.library` | 205828 | `bb73e4983983f8fd609dd95d873311fd355deac48db8ef98dd06953a8f8fa188` |
| `Library/motor3_3103.library` | 205757 | `0cd204574adce6931cd3e91931c5b1db9b18491c4fcf91a2a8d6fa43b09f623c` |
| `Library/motor3_3104.library` | 208713 | `52858f6d18a1c07236f603f11a96440e45bb00064e9fb48594f8d3227b356180` |
| `Library/motor3_add3D.library` | 198655 | `098399e94babbe1c0f2c42f5c97ef6abacd43281aadea01a392856170917b417` |
| `Library/td3_31012.library` | 192086 | `51ca6b3ff065fc6eaf40af581f56a2543aacc71ce969383ab137080c835f7bb8` |
| `Library/td3_31013.library` | 192339 | `9477b938677f88fa90d11a846b160d429a415be7ca1ac68733bed3e24f2969b7` |
| `Library/td3_3102.library` | 217979 | `3a4907dcb9a4f1eb81af457e34e70f1d3fdb0ae9ac8843a382a461b74989b394` |
| `Library/td3_3104.library` | 189048 | `db10ce711eeb527d4504826d5dc805e0991c34f9bfd94edbc2dc9fbb5b05e963` |
| `Library/td3_3105.library` | 192402 | `2a0f6e50b943ffbbab3d01ccfcddeec3b684db072ffef86ec405a23e5d0b1aef` |
| `Library/td3_3106.library` | 189884 | `5e4c427d550ae412b53be3023e75a6041011e9a7d6e8da3efe75cbf986b27167` |
| `Library/td3_3107.library` | 190292 | `9e6597252e9c764327604cada07c4d96e7d5f0d580fe3e19302fc32bf500f7b1` |
| `Library/td3_3108.library` | 193347 | `8239c433e240d708f72e16c8aa3319d4f81b9469860444e8de0f8be923c1a94a` |
| `Library/td3_3109.library` | 191194 | `6c9f162f367d82ad124a360dac5c4c19ee7de72aa08b2f0ece5016423c7abb2a` |
| `Production_dev/libraries/motor3_3105.library` | 208554 | `c97b465c0b714098ffcbd94d30c0d5a60d36171a83fb535d1d2e30837b95638d` |
| `Production_dev/libraries/td3_31010.library` | 191784 | `e0e395fb7b21352f48011bfdbdddf0141c3f4630e3f281b4ed1e7a7049302560` |
| `Production_dev/libraries/td3_3101011_SP21.library` | 341878 | `09b39f6f5a590b308c75d958e7bc45b5aca9dc080915c32b02cb11ed634135c9` |
| `Production_dev/libraries/td3_31011.library` | 191247 | `63bbf6fd30ab55fa87fc3de19aaa0bed77ad80a03ee4f900482144eb969ac1b5` |
| `Production_dev/libraries/td3_31012.library` | 191915 | `3931e3bc37a78029ae3db0a2609619f508a7815741ac02f734fd763cb58a6930` |
| `Production_dev/libraries/td3_31013.library` | 192339 | `9477b938677f88fa90d11a846b160d429a415be7ca1ac68733bed3e24f2969b7` |
