export interface TomraModel {
  metadata: TomraMedata;
  machine: TomraMachine;
  bins: TomraBin[];
  table: TomraTable;
  crateConveyor: TomraCrateConveyor;
  connection: TomraConnection;
  cleaning: TomraCleaning;
  assistant: TomraAssistant;
  paymentTerminal: TomraPaymentTerminal;
}

// Metadata
export interface TomraMedata {
  rvm: TomraRvm;
  location: TomraLocation;
}

export interface TomraRvm {
  serialNumber: string;
  type: string;
}

export interface TomraLocation {
  customerId: string;
  name: string;
}

// Machine
//up, down
export interface TomraMachine {
  status: string;
  details: TomraMachineDetails[];
  updatedAt: Date;
}

//chamberBlocked, closed, closedUpdate, emergency, emptyingBin,
//errorBackroom, errorOther, frontDoorOpen, fullBin, fullConveyor, fullTable,
//printerOutOfPaper, printerStoreResolvable, printerOther, standby, temporaryClosed,
//temporaryClosedRearDoorOpen, temporaryClosedMachineBeingEmptied, temporaryClosedResetButton, temporaryClosedNeedsEmptying, temporaryClosedBackroomNotReady, other

export interface TomraMachineDetails {
  reason: string;
}

//Bin
//ok, semiFull, full
export interface TomraBin {
  id: string;
  status: string;
  updatedAt: Date;
}

//Table
//ok, semiFull, full
export interface TomraTable {
  status: string;
  updatedAt: Date;
}

//CrateConveyor
export interface TomraCrateConveyor {
  status: string;
  updatedAt: Date;
}

//Connection
//online, offline
export interface TomraConnection {
  lastSeenAt: Date;
  status: string;
}

//Cleaning
//ok, extensiveCleaningOverdue, extensiveCleaningSoonOverdue, shortCleaningOverdue
export interface TomraCleaning {
  status: string;
}

export interface TomraAssistant {
  requestedAt: Date;
}

//PaymentTerminal
//up, down
export interface TomraPaymentTerminal {
  status: string;
  updatedAt: Date;
  reason: string;
}
