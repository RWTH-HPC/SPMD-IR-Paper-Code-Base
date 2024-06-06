# Directory Structure
- The directory "Microbenchmarks-PARCOACH" contains in the "mpi" sub-directory the codes originating from: "https://github.com/parcoach/microbenchmarks". The sub-directories "shmem" and "nccl" contain respectively the ports of the MPI codes.
- The directory "ExtensionToMicrobenchSuite" contains in the respective programming model (combination) sub-directory the newly created cases.
- Each programming model sub-directory includes next to the C/C++ codes the sub-directories "mlir", "mv", and "spmd". While "mlir" includes the representation of the codes in MLIR after cgeist and polygeist have been applied, "spmd" and "mv" respectively contain the representation in MLIR after subsequently appliying the Unification Pass and MV-Analysis Pass.

# Individual Results
In the following, the categorization from PARCOACH-static vs. the extended verification on the SPMD IR for the individual test cases is presented.  In the tables, we shorten the names of the test cases to their case number and whether an error is present.
Legend:
TP=True Positive, FP=False Positive, TN=True Negative, FN=False Negative, NS=Not Supported, NP=Not Portable

## Microbenchmarks PARCOACH
### MPI:
|Case | PARCOACH | SPMD IR Verification
|--|--|--|
| 01-yes |  TP | TP 
| 02-yes |  TP | TP
| 03-yes |  TP | TP
| 04-no |  TN | TN
| 05-yes |  TP | TP
| 06-yes |  TP | TP
| 07-yes |  TP | TP
| 08-yes |  TP | TP
| 09-yes |  TP | TP
| 10-yes |  TP | TP
| 11-no |  TN | TN
| 12-no |  FP | FP
| 13-yes |  TP | TP
| 14-yes |  TP | TP
| 15-yes |  TP | TP

### SHMEM:
|Case | PARCOACH | SPMD IR Verification
|--|--|--|
| 01-yes |  NS | TP 
| 02-yes |  NS | TP
| 03-yes |  NS | TP
| 04-no |  NS | TN
| 05-yes |  NS | TP
| 06-yes |  NS | TP
| 07-yes |  NS | TP
| 08-yes |  NS | TP
| 09-yes | NP  | NP
| 10-yes |  NS | TP
| 11-no |  NS | TN
| 12-no |  NS | FP
| 13-yes |  NS | TP
| 14-yes |  NS | TP
| 15-yes |  NS | TP

### NCCL:
- Expected category of Case 09 changed from TP to TN due to port

|Case | PARCOACH | SPMD IR Verification
|--|--|--|
| 01-yes |  NS | TP 
| 02-yes |  NS | TP
| 03-yes |  NS | TP
| 04-no |  NS | TN
| 05-yes |  NS | TP
| 06-yes |  NS | TP
| 07-yes |  NS | TP
| 08-yes |  NS | TP
| 09-yes | NS  | FP
| 10-yes |  NS | TP
| 11-no |  NS | TN
| 12-no |  NS | FP
| 13-yes |  NS | TP
| 14-yes |  NS | TP
| 15-yes |  NS | TP

## Custom Test Cases
### MPI:
|Case | PARCOACH | SPMD IR Verification
|--|--|--|
| 01-yes |  TP | TP 
| 02-no |  TN | TN
| 03-no |  TN | TN
| 04-yes |  TP | TP
| 05-no |  TN | TN
| 06-no |  TN | TN
| 07-yes |  TP | TP
| 08-yes |  TP | TP
| 09-no |  TN | TN
| 10-no |  TN | TN
| 11-yes |  FN | FN
| 12-yes |  FN | FN
| 13-no |  FP | TN
| 14-no |  FP | TN
| 15-yes |  TP | TP
| 16-yes |  TP | TP
| 17-yes |  TP | TP
| 18-yes |  TP | TP
| 19-yes |  TP | TP
| 20-yes |  TP | TP
| 21-yes |  TP | TP
| 22-yes |  TP | TP
| 23-yes |  TP | TP
| 24-yes |  TP | TP

### SHMEM:
|Case | PARCOACH | SPMD IR Verification
|--|--|--|
| 01-yes |  NS | TP 
| 02-no |  NS | TN
| 03-no |  NS | TN
| 04-yes |  NS | TP
| 05-no |  NS | TN
| 06-no |  NS | TN
| 07-yes |  NS | TP
| 08-yes |  NS | TP
| 09-no |  NS | TN
| 10-no |  NS | TN
| 11-yes |  NS | FN
| 12-yes |  NS | FN
| 13-no |  NS | TN
| 14-no |  NS | TN

### SHMEM:
|Case | PARCOACH | SPMD IR Verification
|--|--|--|
| 01-yes |  NS | TP 
| 02-no |  NS | TN
| 03-no |  NS | TN
| 04-yes |  NS | TP
| 05-no |  NS | TN
| 06-no |  NS | TN
| 07-yes |  NS | TP
| 08-yes |  NS | TP
| 09-no |  NS | TN
| 10-no |  NS | TN
| 11-yes |  NS | FN
| 12-yes |  NP | NP
| 13-no |  NS | TN
| 14-no |  NS | TN

### MPI+SHMEM:
|Case | PARCOACH | SPMD IR Verification
|--|--|--|
| 03-a-no |  NS | TN
| 03-b-no |  NS | TN
| 04-a-yes |  NS | TP
| 04-b-yes|  NS | TP

### MPI+NCCL:
|Case | PARCOACH | SPMD IR Verification
|--|--|--|
| 03-no |  NS | TN
| 04-yes |  NS | TP

### SHMEM+NCCL:
|Case | PARCOACH | SPMD IR Verification
|--|--|--|
| 03-no |  NS | TN
| 04-yes |  NS | TP