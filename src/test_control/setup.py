from setuptools import setup

package_name = 'test_control'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        ('share/' + package_name + '/launch', ['launch/test_world.launch.py']),
        ('share/' + package_name + '/config', ['config/test_controllers.yaml']),
        ('share/' + package_name + '/urdf', ['urdf/test.urdf']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='wintunlatt',
    maintainer_email='wintunlatt@example.com',
    description='Test control package with hinge joint',
    license='Apache License 2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'hinge_commander = test_control.hinge_commander:main',
        ],
    },
)
