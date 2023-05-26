data "aws_vpc" "main" {
  tags = {
    Name = "${local.global.base_vpc.prefix}-main"
  }
}
data "aws_subnet" "public" {
  count  = 2
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "${local.global.base_vpc.prefix}-public-${data.aws_availability_zone.az[count.index].name_suffix}"
  }
}
data "aws_subnet" "private" {
  count  = 2
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "${local.global.base_vpc.prefix}-private-${data.aws_availability_zone.az[count.index].name_suffix}"
  }
}
