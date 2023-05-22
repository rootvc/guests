import Bluetooth from "@/app/components/Bluetooth";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div>
        <Bluetooth />
      </div>
    </main>
  );
}
