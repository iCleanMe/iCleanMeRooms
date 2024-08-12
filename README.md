
# iCleanMeRooms

## Overview

The iCleanMeRooms module is a core feature package designed specifically for the iCleanMe app. It provides all the necessary functionalities for managing rooms within the application. This includes the ability to add, edit, reorder, and delete both household and personal rooms. The module integrates with the shared UI and accessibility components, making it a seamless part of the overall iCleanMe experience.

## Features

### Room Management
- **Add New Rooms**: Users can create new rooms, categorizing them as either personal or household rooms. Personal rooms are private to the user, while household rooms are shared among all users in the household.
- **Edit Rooms**: Users can update room details, such as the room name.
- **Delete Rooms**: Users can delete rooms. When deleting a room, any tasks associated with that room are also removed. However, this module does not allow direct management of tasks—users can only view them when preparing to delete a room.
- **Reorder Rooms**: Users can reorder rooms within their respective categories (household or personal) to suit their preferences.

### Personal vs. Household Rooms
- **Personal Rooms**: These rooms are accessible only by the user who created them. The module restricts certain actions based on whether a room is categorized as personal or household.
- **Household Rooms**: These rooms are shared among all household members. The module allows any user with appropriate permissions to manage these rooms.

### Accessibility
- **Accessibility Identifiers**: The module leverages the `iCleanMeRoomsAccessibility` package to ensure that all interactive elements are accessible in UI tests (done in the main app target).

### UI Integration
- **Shared UI Components**: The iCleanMeRooms module relies on components from the iCleanMeSharedUI package to maintain a consistent look and feel across the app. This includes buttons, text styles, and layout components.

## Architecture
The iCleanMeRooms module is built with a focus on modularity and separation of concerns:

- **View Models**: Each view in the module is backed by a dedicated ViewModel that handles business logic and data manipulation. The ViewModels communicate with data sources to fetch and update room information.
- **Data Sources**: The `RoomDataSource` class provides the necessary data for the ViewModels, ensuring that the data is always up-to-date and consistent across the app.
- **Delegates and Handlers**: The module uses protocols to define interactions between different components, such as navigating between views or updating room details.

## Testing
This package includes a comprehensive test suite with both unit and integration tests:

- **Unit Tests**: The unit tests cover individual components, such as ViewModels and data sources, ensuring that each piece of the module behaves as expected.
- **Integration Tests**: The integration tests ensure that the various components of the module work together seamlessly, providing a smooth user experience within the iCleanMe app.

## Usage
This module is designed for use within the iCleanMe app. While it is packaged as a separate module for modularity and reusability within the iCleanMe ecosystem, it is not intended for standalone use.

## License
iCleanMeRooms is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact
For any issues, feature requests, or inquiries related to the iCleanMeRooms module, please reach out through the iCleanMe GitHub organization. Contributions, feature requests, and issues are welcomed as part of the ongoing development of the iCleanMe app.
