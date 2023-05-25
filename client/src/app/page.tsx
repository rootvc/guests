import { UserButton, currentUser } from "@clerk/nextjs";
import CheckInStep from "./components/step/check_in_step";
import StepContainer from "./components/step/step_container";

export default async function Home() {
  const { firstName, lastName } = (await currentUser())!;

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="flex flex-col items-center justify-between m-3">
        <UserButton afterSignOutUrl="/" />
        <br /> <h1 className="text-bold">Welcome, {firstName}!</h1>
      </div>
      <div>
        <h2>Steps remaining for access today</h2>
        <StepContainer model={{ label: "Check In" }} Step={CheckInStep} />
      </div>
    </main>
  );
}
