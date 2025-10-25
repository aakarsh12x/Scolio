import boto3
import json
import os
import time

# DynamoDB Local endpoint
dynamodb = boto3.resource('dynamodb', endpoint_url='http://localhost:8000')

# Table definitions
tables = [
    {
        'TableName': 'Users',
        'KeySchema': [
            {'AttributeName': 'username', 'KeyType': 'HASH'},
        ],
        'AttributeDefinitions': [
            {'AttributeName': 'username', 'AttributeType': 'S'},
        ],
        'ProvisionedThroughput': {
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    },
    {
        'TableName': 'Teachers',
        'KeySchema': [
            {'AttributeName': 'teacherId', 'KeyType': 'HASH'},
        ],
        'AttributeDefinitions': [
            {'AttributeName': 'teacherId', 'AttributeType': 'S'},
        ],
        'ProvisionedThroughput': {
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    },
    {
        'TableName': 'Students',
        'KeySchema': [
            {'AttributeName': 'studentId', 'KeyType': 'HASH'},
        ],
        'AttributeDefinitions': [
            {'AttributeName': 'studentId', 'AttributeType': 'S'},
        ],
        'ProvisionedThroughput': {
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    },
    {
        'TableName': 'Classes',
        'KeySchema': [
            {'AttributeName': 'classId', 'KeyType': 'HASH'},
        ],
        'AttributeDefinitions': [
            {'AttributeName': 'classId', 'AttributeType': 'S'},
        ],
        'ProvisionedThroughput': {
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    },
    {
        'TableName': 'Attendance',
        'KeySchema': [
            {'AttributeName': 'attendanceId', 'KeyType': 'HASH'},
        ],
        'AttributeDefinitions': [
            {'AttributeName': 'attendanceId', 'AttributeType': 'S'},
        ],
        'ProvisionedThroughput': {
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    },
    {
        'TableName': 'Notifications',
        'KeySchema': [
            {'AttributeName': 'notificationId', 'KeyType': 'HASH'},
        ],
        'AttributeDefinitions': [
            {'AttributeName': 'notificationId', 'AttributeType': 'S'},
        ],
        'ProvisionedThroughput': {
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    }
]

# Initial data for seeding the database
initial_data = {
    'Users': [
        {
            'username': 'teacher',
            'password': 'password',
            'userType': 'teacher',
            'userId': 'T001',
        },
        {
            'username': 'student',
            'password': 'password',
            'userType': 'student',
            'userId': 'S001',
        },
        {
            'username': 'parent',
            'password': 'password',
            'userType': 'parents',
            'userId': 'P001',
        }
    ],
    'Teachers': [
        {
            'teacherId': 'T001',
            'name': 'Ms. Shaw',
            'email': 'shaw@school.edu',
            'phone': '555-1234',
            'joinDate': '2022-01-15',
            'education': 'Masters in Education',
            'experience': '10 years',
            'bio': 'Experienced teacher specializing in English and Literature',
            'employeeId': 'EMP-T001',
            'classesAssigned': ['C001', 'C002', 'C003', 'C004', 'C005'],
        }
    ],
    'Students': [
        {
            'studentId': 'S001',
            'name': 'John Doe',
            'grade': 'Year 10',
            'parentName': 'Jane Doe',
            'parentId': 'P001',
            'address': '123 Main St, Anytown',
            'phone': '555-5678',
            'email': 'john@student.edu',
            'enrollmentDate': '2022-09-01',
        }
    ],
    'Classes': [
        {
            'classId': 'C001',
            'subject': 'English',
            'teacher': 'Ms. Shaw',
            'teacherId': 'T001',
            'grade': 'Year 10',
            'timeSlot': '08:30 AM - 09:15 AM',
            'description': 'English Grammar and Literature',
            'students': 34,
            'nextHomework': 'No Homework',
        },
        {
            'classId': 'C002',
            'subject': 'Mathematics',
            'teacher': 'Ms. Shaw',
            'teacherId': 'T001',
            'grade': 'Year 11',
            'timeSlot': '09:30 AM - 10:15 AM',
            'description': 'Quadratic Equations and Algebra',
            'students': 32,
            'nextHomework': 'No Homework',
        },
        {
            'classId': 'C003',
            'subject': 'Science',
            'teacher': 'Ms. Shaw',
            'teacherId': 'T001',
            'grade': 'Year 9',
            'timeSlot': '10:30 AM - 11:15 AM',
            'description': 'Chemistry Basics and Lab Work',
            'students': 36,
            'nextHomework': 'No Homework',
        },
        {
            'classId': 'C004',
            'subject': 'History',
            'teacher': 'Ms. Shaw',
            'teacherId': 'T001',
            'grade': 'Year 10',
            'timeSlot': '11:30 AM - 12:15 PM',
            'description': 'World War II and its Impact',
            'students': 33,
            'nextHomework': 'No Homework',
        },
        {
            'classId': 'C005',
            'subject': 'ICT',
            'teacher': 'Ms. Shaw',
            'teacherId': 'T001',
            'grade': 'Year 9',
            'timeSlot': '01:30 PM - 02:15 PM',
            'description': 'Basic Computing and Internet',
            'students': 30,
            'nextHomework': 'No Homework',
        },
    ],
    'Notifications': [
        {
            'notificationId': '1683824400000',
            'title': 'Parent-Teacher Meeting',
            'message': 'Parent-Teacher Meeting scheduled for next Monday at 4 PM.',
            'type': 'announcement',
            'timestamp': '1683824400000',
            'sender': 'System',
            'recipients': ['all'],
        },
        {
            'notificationId': '1683910800000',
            'title': 'School Holiday',
            'message': 'School will remain closed on May 15th for Teacher Training Day.',
            'type': 'announcement',
            'timestamp': '1683910800000',
            'sender': 'Admin',
            'recipients': ['all'],
        },
    ],
}

def create_tables():
    """Create all the required tables in DynamoDB Local"""
    existing_tables = [table.name for table in dynamodb.tables.all()]
    
    for table_def in tables:
        table_name = table_def['TableName']
        if table_name not in existing_tables:
            print(f"Creating table: {table_name}")
            try:
                table = dynamodb.create_table(**table_def)
                print(f"Waiting for table {table_name} to be created...")
                table.meta.client.get_waiter('table_exists').wait(TableName=table_name)
                print(f"Table {table_name} created successfully!")
            except Exception as e:
                print(f"Error creating table {table_name}: {str(e)}")
        else:
            print(f"Table {table_name} already exists, skipping.")

def insert_initial_data():
    """Insert initial data into the tables"""
    for table_name, items in initial_data.items():
        table = dynamodb.Table(table_name)
        
        print(f"Inserting data into {table_name}...")
        for item in items:
            try:
                table.put_item(Item=item)
                print(f"  Added item: {json.dumps(item)[:50]}...")
            except Exception as e:
                print(f"Error inserting item into {table_name}: {str(e)}")

def list_all_tables():
    """List all tables in DynamoDB Local"""
    print("\nExisting tables:")
    for table in dynamodb.tables.all():
        print(f"- {table.name}")

def dump_table_data(table_name):
    """Dump all data from a table"""
    table = dynamodb.Table(table_name)
    response = table.scan()
    items = response.get('Items', [])
    
    print(f"\nData in {table_name} table:")
    for item in items:
        print(json.dumps(item, indent=2))

if __name__ == "__main__":
    print("Creating DynamoDB tables for School Management System...")
    
    create_tables()
    insert_initial_data()
    list_all_tables()
    
    # Dump data from each table for verification
    for table_name in initial_data.keys():
        dump_table_data(table_name)
    
    print("\nSetup completed successfully!") 