# Payload Activity Monitor
A lightweight API service designed to track user activities such as deposits and withdrawals. The application provides alert functionality based on predefined rules, allowing users to monitor financial activities in real-time. This service is built with Ruby on Rails, containerized with Docker for easy deployment, and can be tested via a /event API endpoint.

The application has been designed to gracefully handle errors and a wide range of edge cases.

## Tech Stack
- Ruby on Rails
- Docker
- SQLite
- Puma
- Git & GitHub
- Docker Hub

## How to Use
- **Endpoint**: `/event`
- **Method**: `POST`
- **Description**: Accepts user activities (like deposits or withdrawals) and checks predefined rules to determine if an alert is raised.

**Sample Request**:
```
curl -X POST http://localhost:3000/event -H 'Content-Type: application/json' \
-d '{"type": "deposit", "amount": 50, "user_id": 1, "time": 1}'
```

## Parameters' Essentials

| Parameter | Type    | Required | Description                                       |
|-----------|---------|----------|---------------------------------------------------|
| `type`    | String  | Yes      | The type of action (`deposit` or `withdrawal`).   |
| `amount`  | Float   | Yes      | The amount involved in the action.                |
| `user_id` | Integer | Yes      | The ID of the user performing the action.         |
| `time`    | Integer | Yes      | Timestamp of when the action occurred (in seconds). |

## Usage / Examples
Here are some examples of valid `POST` requests to test the `/event` endpoint:

```bash
# Example 1: Deposit
curl -X POST http://localhost:3000/event -H 'Content-Type: application/json' \ -d '{"type": "deposit", "amount": 100, "user_id": 1, "time": 1618304476}'

# Example 2: Withdrawal
curl -X POST http://localhost:3000/event -H 'Content-Type: application/json' \ -d '{"type": "withdrawal", "amount": 200, "user_id": 2, "time": 1618304480}'
```

## How to Pull and Run the GitHub Repo
1. **Clone the Repository**:
   ```
   git clone https://github.com/AmaraFinbarrs/payload-activity-monitor.git
   ```
2. **Navigate to the Project Directory**:
   ```
   cd payload-activity-monitor
   ```
3. **Install Dependencies**:
   ```
   bundle install
   ```
2. **Setup the Database**:
   ```
   rails db:create db:migrate
   ```
3. **Start the Rails Server**:
   ```
   rails server
   ```
The app will be accessible at `http://localhost:3000`.

## How to Pull and Run the Docker Image
1. **Install Docker**

   Make sure Docker is installed on your system. Follow the [official Docker installation guide](https://docs.docker.com/get-docker/) if you haven't installed Docker yet.

2. **Pull the Image from Docker Hub**
   ```
   docker pull amarafinbarrs/payload-activity-monitor:latest
   ```
3. **Run the Container mapping port 3000 to your local machine**
   ```
   docker run -p 3000:3000 amarafinbarrs/payload-activity-monitor:latest
   ```

4. **Access the API endpoint using the curl command**
   ```
   curl -X POST http://localhost:3000/event -H 'Content-Type: application/json' \ -d '{"type": "deposit", "amount": 50, "user_id": 1, "time": 1}' ```
   
## Acknowledgments
- [Ruby on Rails](https://rubyonrails.org/)
- [Docker](https://www.docker.com/)
- [SQLite](https://www.sqlite.org/index.html)

