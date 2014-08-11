class Params

  def edit_params
    {
      email: "bruce_wayne@example.com",
      attributes: {
        new_record:false,
        AMA__eNEWS:"0",
        AMA__TRAVEL__eSpecials: "0",
        AMA__TRAVEL__Weekly: "0",
        amadealsdiscounts: "1",
        personal_vehicle_reminder: "",
        business_vehicle_reminder: "",
        associate_vehicle_reminder: "",
        fleet_contact: "0",
        personal_vehicle_reminder_flag: "0",
        business_vehicle_reminder_flag: "0",
        associate_vehicle_reminder_flag: "0",
        email__address: "bruce_wayne@example.com"}
     }
  end

  def add_params
    {
      email: "bruce_wayne@example.com",
      attributes: {
        new_record: false,
        AMA__eNEWS: "0",
        AMA__TRAVEL__eSpecials: "0",
        AMA__TRAVEL__Weekly: "1",
        amadealsdiscounts: "0",
        personal_vehicle_reminder: "",
        business_vehicle_reminder: "",
        associate_vehicle_reminder: "",
        fleet_contact: "0",
        personal_vehicle_reminder_flag: "0",
        business_vehicle_reminder_flag: "0",
        associate_vehicle_reminder_flag: "0",
        email__address: "bruce_wayne@example.com"}
    }
  end
end
