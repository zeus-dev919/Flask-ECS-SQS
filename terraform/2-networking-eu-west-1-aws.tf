resource "aws_vpc" "flask_app" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "MyCoolVPC"
  }
}

resource "aws_internet_gateway" "flask_app" {
  vpc_id = aws_vpc.flask_app.id

  tags = {
    Name = "MyCoolInternetGateway"
  }
}

resource "aws_subnet" "public_1a" {
  cidr_block              = "10.10.1.0/24"
  vpc_id                  = aws_vpc.flask_app.id
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PUB_SUBNET_1"
  }
}

resource "aws_subnet" "public_1b" {
  cidr_block              = "10.10.2.0/24"
  vpc_id                  = aws_vpc.flask_app.id
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "PUB_SUBNET_2"
  }
}

resource "aws_subnet" "private_1a" {
  cidr_block              = "10.10.3.0/24"
  vpc_id                  = aws_vpc.flask_app.id
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "PRV_SUBNET_1"
  }
}

resource "aws_subnet" "private_1b" {
  cidr_block              = "10.10.4.0/24"
  vpc_id                  = aws_vpc.flask_app.id
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "PRV_SUBNET_2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.flask_app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.flask_app.id
  }

  tags = {
    Name = "Public_RT"
  }
}

resource "aws_default_route_table" "private" {
  default_route_table_id = aws_vpc.flask_app.default_route_table_id

  tags = {
    Name = "Private_RT"
  }
}

resource "aws_route_table_association" "subnet_1a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_1a.id
}

resource "aws_route_table_association" "subnet_1b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_1b.id
}