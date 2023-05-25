"use client";

import { partial } from "lodash";

export type TUpdate = (update: Partial<StepState>) => Promise<StepState>;

export type StepModel = {
  label: string;
};

export type StepState = {
  name: string;
  completed: boolean;
  [meta: string]: string | boolean;
};

export type StepProps = {
  step: StepModel;
  state: StepState;
  updateStep: TUpdate;
  userId: string;
};

export type StepFullProps = StepProps & {
  action: (update: TUpdate) => void;
};

export const Step = ({ step, state, action, updateStep }: StepFullProps) => {
  return (
    <button
      className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      onClick={partial(action, updateStep)}
    >
      {step.label}
    </button>
  );
};
