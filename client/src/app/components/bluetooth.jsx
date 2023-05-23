"use client";

const Bluetooth = () => {
  const getDevice = async () => {
    let devices = await navigator.bluetooth.requestDevice({
      filters: [{ services: ["39ed98ff-2900-441a-802f-9c398fc199d2"] }]
    });
    console.log(devices);
  };
  return (
    <button
      className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      onClick={getDevice}
    >
      Check In
    </button>
  );
};
export default Bluetooth;
