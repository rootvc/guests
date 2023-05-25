import { currentUser } from "@clerk/nextjs";
import { kv } from "@vercel/kv";
import { snakeCase } from "lodash";
import { StepModel, StepState } from "./step";

const StepContainer = async ({
  model,
  Step,
}: {
  model: StepModel;
  Step: React.ElementType;
}) => {
  const { id } = (await currentUser())!;

  let name = snakeCase(model.label);
  let step = await kv.get<StepState>(name);
  if (!step) {
    step = { name, completed: false };
    await kv.set(name, step, { ex: 60 * 60 * 24 });
  }

  let updateStep = async (update: Partial<StepState>): Promise<StepState> => {
    "use server";
    let newStep = { ...step, ...update };
    await kv.set(name, newStep, { ex: 60 * 60 * 24 });
    return newStep as StepState;
  };

  return <Step step={model} state={step} updateStep={updateStep} userId={id} />;
};

export default StepContainer;
