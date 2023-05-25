"use client";

import { partial } from "lodash";
import { Step, StepProps, TUpdate } from "./step";

const GUEST_SERVICE = "9b5397cb-c6b3-4f53-9182-741b79f5c920";
const USER_ID = "0x2AC3";
const ACCESS_CODE = "e9b4a846-e002-4097-9210-10da573e6ce5";

const getDevice = async (userId: string, complete: TUpdate) => {
  let device = await navigator.bluetooth.requestDevice({
    filters: [{ services: [GUEST_SERVICE] }],
  });
  await device!.gatt!.connect();
  let service = await device!.gatt!.getPrimaryService(GUEST_SERVICE);
  let userIdChar = await service.getCharacteristic(USER_ID);
  let accessCodeChar = await service.getCharacteristic(ACCESS_CODE);

  await userIdChar.writeValue(new TextEncoder().encode(userId));
  let accessCode = new TextDecoder().decode(await accessCodeChar.readValue());
  console.log(accessCode);

  complete({ completed: true, code: accessCode });
};

const CheckInStep = (props: StepProps) => {
  return <Step {...props} action={partial(getDevice, props.userId)} />;
};

export default CheckInStep;
