import subprocess
import time


def wait_for_db(config, max_retries=5, delay_seconds=5):
    """Wait for PostgreSQL to become available with retries."""
    retries = 0
    while retries < max_retries:
        try:
            conn = connect(**config)
            conn.close()
            print(f"Successfully connected to {config['host']}")
            return True
        except OperationalError as e:
            retries += 1
            print(f"Attempt {retries}/{max_retries} - Connection to {config['host']} failed: {e}")
            if retries < max_retries:
                print(f"Waiting {delay_seconds} seconds before retrying...")
                time.sleep(delay_seconds)
    raise Exception(f"Could not connect to {config['host']} after {max_retries} attempts")

# Database configurations
source_config = {
    'host': 'source_db',
    'port': '5432',
    'dbname': 'sourcedb',
    'user': 'sourceuser',
    'password': 'sourcepass'
}

dest_config = {
    'host': 'destination_db',
    'port': '5432',
    'dbname': 'destdb',
    'user': 'destuser',
    'password': 'destpass'
}
 
dump_command = [
    'pg_dump',
    '-h', source_config['host'],
    '-p', source_config['port'],
    '-U', source_config['user'],
    '-d', source_config['dbname'],
    '-F', 'data_dump.sql',
    '-w'
]
    
subprocess_env = dict(PGPASSWORD=source_config['password'])

subprocess.run(dump_command, env=subprocess_env, check=True)


load_command = [
    'psql',
    '-h', dest_config['host'],
    '-p', dest_config['port'],
    '-Us', dest_config['user'],
    '-d', dest_config['dbname'],
    '-a', '-f', 'data_dump.sql'
]
    
subprocess_env = dict(PGPASSWORD=dest_config['password'])

subprocess.run(load_command, env=subprocess_env, check=True)


print("Ending ELT script...")
    