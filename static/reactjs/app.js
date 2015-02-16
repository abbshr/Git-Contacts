var App = React.createClass({
  render: function () {
    var ret;
    switch (this.state.layer) {
      case 'contacts':
        ret = (
          <NavBar  />
          <ContactsList  data={this.state.data}/>
        );
      case 'card':
        ret = (
          <NavBar  />
          <CardList data={this.state.data} />
        );
    }
    return ret;
  },
  getInitialState: function () {
    return { data: [], layer: 'contacts' };
  },
  createContacts: function () {},
  queryContacts: function () {},
  getPersonalInfo: function () {},
  getAllRequests: function () {},
  logout: function () {},
  getHistory: function () {},
  revertHisotry: function () {},
  createCard: function () {},
  deleteCard: function () {},
  modifyCard: function () {},
  queryCards: function () {},
  getCard: function () {},
  getUsers: function () {},
  addUser: function () {},
  delUser: function () {},
  updateUserPrivilege: function () {},
  getUser: function () {}
});

var NavBar = React.createClass({
  render: function () {
    return (
      <div className="row">
        <div className="col-md-10 col-md-offset-1">
          <nav className="navbar navbar-default">
            <div className="container-fluid">
              <div className="navbar-header">
                <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                  <span className="sr-only">Toggle navigation</span>
                  <span className="icon-bar"></span>
                  <span className="icon-bar"></span>
                  <span className="icon-bar"></span>
                </button>
                <a className="navbar-brand" href="/">
                  <i className="fa fa-git-square fa-2"></i> 
                  Git Contacts
                </a>
              </div>
              <div className="collapse navbar-collapse">
                <ul className="nav navbar-nav">
                  <li><a href="#" ref='create'>
                    创建群组 <i className="fa fa-users fa-1"></i>
                  </a></li>
                </ul>
                <form className="navbar-form navbar-left" role="search" onSubmit={this.onSubmit}>
                  <div className="form-group">
                    <input type="text" className="form-control" placeholder="查找群组" ref='query' />
                  </div>
                </form>
                <ul className="nav navbar-nav">
                  <li><a href="#">个人信息 <i className="fa fa-user"></i></a></li>
                  <li><a href="#">全部请求 <i className="fa fa-rocket"></i></a></li>
                  <li><a href="#" onClick={this.onClick}>注销 <i className="fa fa-sign-out"></i></a></li>
                </ul>
              </div>
            </div>
          </nav>
        </div>
      </div>
    );
  },
  onClick: function () {
    $.ajax({
      url: '/logout',
      dataType: 'json',
      type: "GET",
      success: function (data) {
        window.location.reload();
      }
    });
  },
  onSubmit: function () {
    e.preventDefault();
    var qs = this.refs.query.getDOMNode().value.trim();
    var data = qs.split(';');
  
    $.ajax({
      url: '/contacts',
      dataType: 'json',
      type: "GET",
      data: qs
      success: function (data) {
        
      }
    });
  }
});

var ContactsList = React.createClass({
  render: function () {
    var list = this.props.data.map(function (contacts) {
      return (
        <div className="col-md-4">
          <Contacts data={contacts}/>
        </div>
      );
    });
    return (
      <div className="row">
        {list}
      </div>
    );
  }
});

var Contacts = React.createClass({
  render: function () {
    return (
      <div className="panel panel-default">
        <div className="panel-body">
          <h4 className="text-center">{this.props.name}</h4>
        </div>
        <div className="panel-footer">
          <p className="text-justify">
            人数: {this.props.count},
            创建者: {this.props.owner},
            ID: {this.props.gid}
          </p>
        </div>
      </div>
    );
  }
});

var CardList = React.createClass({
  render: function () {
    var list = this.props.data.map(function (card) {
      return (
        <div className="col-md-6">
          <Card data={card} />
        </div>
      );
    });
    return (
      <div className="row">
        {list}
      </div>
    );
  }
});

var Card = React.createClass({
  render: function () {
    var tbody = Object.keys(this.props.data).map(function (k) {
      return (
        <tr>
          <th scope="row">{k}</th>
          <td>{this.props.data[k]}</td>
        </tr>
      );
    });
    return (
      <div class="panel panel-default">
        <div class="panel-heading">Panel heading</div>
        <div class="panel-body">
          <p>Some default panel content here. Nulla vitae elit libero, a pharetra augue. Aenean lacinia bibendum nulla sed consectetur. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
        </div>
        <table class="table">
          <tbody>
            {tbody}
          </tbody>
        </table>
      </div>
    );
  }
});

React.render(<App />, document.querySelector('#main'));