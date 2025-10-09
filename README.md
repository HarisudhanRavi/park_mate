# ParkMate

**ParkMate** is an Elixir project for **managing parking spaces**.  
It uses a **GenServer** to maintain the state of parking spots, allowing you to track, reserve, and free parking spaces efficiently.

---

## Features

- Track all parking spaces with occupancy status.  
- Reserve (park) a vehicle into a specific spot.  
- Release (unpark) a vehicle from a spot.  
- Query all spots or only free spots.  
- Lightweight and fast, suitable for concurrent usage.

---

## Running the Project

Start the project in interactive mode:
```bash
iex -S mix
```

## Usage

All parking operations are handled through the GenServer API:
```elixir
# List all parking spaces
ParkMate.Parking.Manager.get_all_spaces()

# List only free spaces
ParkMate.Parking.Manager.get_free_spaces()

# Park a vehicle
ParkMate.Parking.Manager.park(:floor_1, :spot_1, "TN001")

# Unpark a vehicle
ParkMate.Parking.Manager.unpark(:floor_1, :spot_1)

# Get all parking logs
 ParkMate.Parking.ParkingLogs.get_all_logs()

# Get all parking logs for a vehicle
 ParkMate.Parking.ParkingLogs.get_all_logs("TN001")

# Get the latest log for a vehicle
 ParkMate.Parking.ParkingLogs.get_latest_log("TN001")
```

## Learn more about Elixir/Phoenix

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
