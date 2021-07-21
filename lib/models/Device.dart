enum DeviceStatus {
  PENDING,
  READY,
}

class DeviceCard {
  String imei;
  String name;
  DeviceStatus status;

  DeviceCard({
    this.imei,
    this.name,
    this.status,
  });
}
